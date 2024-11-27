import SwiftUI

// MODEL
struct Contact: Identifiable {
    let id: UUID = UUID()
    var name: String
    var phoneNumber: String
    var email: String
    var address: String
}

// VIEW-MODEL
class ContactsViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var searchQuery: String = ""
    
    //add
    func addContact(name: String, phoneNumber: String, email: String, address: String) {
        let newContact = Contact(name: name, phoneNumber: phoneNumber, email: email, address: address)
        contacts.append(newContact)
    }
    
    //edit
    func editContact(contact: Contact, newName: String, newPhoneNumber: String, newEmail: String, newAddress: String) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts[index].name = newName
            contacts[index].phoneNumber = newPhoneNumber
            contacts[index].email = newEmail
            contacts[index].address = newAddress
        }
    }
    
    //delete
    func deleteContact(contact: Contact) {
        contacts.removeAll { $0.id == contact.id }
    }

    //search
    var searchContacts: [Contact] {
        if searchQuery.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }
}

// VIEW
struct ContentView: View {
    @StateObject private var viewModel = ContactsViewModel()
    @State private var isAddingContact = false
    @State private var currentContact: Contact?
    @State private var newContactName = ""
    @State private var newContactPhone = ""
    @State private var newContactEmail = ""
    @State private var newContactAddress = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                TextField("Пошук:", text: $viewModel.searchQuery)
                    .padding()
                
                //contacts
                List {
                    ForEach(viewModel.searchContacts) { contact in
                        HStack {
                            Text(contact.name)
                            Spacer()
                            Button(action: {
                                editContact(contact)
                            }) {
                                Text("редагувати")
                                    .foregroundColor(.orange)
                            }
                            Button(action: {
                                viewModel.deleteContact(contact: contact)
                            }) {
                                Text("видалити")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                
                //add btn
                Button(action: {
                    isAddingContact = true
                    resetTempFields()
                }) {
                    Text("Додати новий контакт")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isAddingContact) {
                    changeContactView
                }
            }
            .navigationTitle("Контакти")
        }
    }
    

    var changeContactView: some View {
        VStack {
            Text("Ім'я:")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            TextField(text: $newContactName)
                .padding()
                .cornerRadius(5)

            Text("Номер телефону:")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            TextField(text: $newContactPhone)
                .padding()
                .cornerRadius(5)


            Text("Електронна пошта:")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            TextField(text: $newContactEmail)
                .padding()
                .cornerRadius(5)

            Text("Адреса:")
                .font(.title)
                .foregroundColor(.green)
                .padding()
            TextField(text: $newContactAddress)
                .padding()
                .cornerRadius(5)
            
            Button(action: {
                if let contact = currentContact {
                    viewModel.editContact(contact: contact, newName: newContactName, newPhoneNumber: newContactPhone, newEmail: newContactEmail, newAddress: newContactAddress)
                } else {
                    viewModel.addContact(name: newContactName, phoneNumber: newContactPhone, email: newContactEmail, address: newContactAddress)
                }
                isAddingContact = false
                currentContact = nil
            }) {
                Text(currentContact == nil ? "Додати контакт" : "Оновити контакт")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
    

    private func editContact(_ contact: Contact) {
        newContactName = contact.name
        newContactPhone = contact.phoneNumber
        newContactEmail = contact.email
        newContactAddress = contact.address
        currentContact = contact
        isAddingContact = true
    }
    
    private func resetTempFields() {
        newContactName = ""
        newContactPhone = ""
        newContactEmail = ""
        newContactAddress = ""
        currentContact = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
