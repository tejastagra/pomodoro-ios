//
//  TodoView.swift
//  TomatoTime
//
//  Created by Tejas Tagra on 15/6/2025.
//

import SwiftUI

struct TodoView: View {
    @AppStorage("todos") private var todosData: Data = Data()
    @State private var todos: [TodoItem] = []
    @State private var newTask: String = ""
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                HStack {
                    TextField("Add a new task", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: addTask) {
                        Image(systemName: "plus")
                            .padding(8)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)

                if !todos.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(todos) { todo in
                                HStack {
                                    Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(todo.isDone ? .green : .gray)
                                        .onTapGesture {
                                            toggle(todo)
                                        }

                                    Text(todo.title)
                                        .font(.body)
                                        .strikethrough(todo.isDone, color: .gray)

                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
                            }
                            .onMove(perform: move)
                        }
                        .padding()
                    }
                } else {
                    Spacer()
                    Text("No tasks yet").foregroundColor(.gray)
                    Spacer()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All", role: .destructive, action: clearAll)
                }
            }
            .environment(\.editMode, $editMode)
            .onAppear(perform: loadTodos)
        }
    }

    func addTask() {
        let trimmed = newTask.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        todos.append(TodoItem(title: trimmed, isDone: false))
        newTask = ""
        saveTodos()
    }

    func toggle(_ todo: TodoItem) {
        if let i = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[i].isDone.toggle()
            saveTodos()
        }
    }

    func clearAll() {
        todos.removeAll()
        saveTodos()
    }

    func move(from source: IndexSet, to destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
        saveTodos()
    }

    func saveTodos() {
        if let data = try? JSONEncoder().encode(todos) {
            todosData = data
        }
    }

    func loadTodos() {
        if let decoded = try? JSONDecoder().decode([TodoItem].self, from: todosData) {
            todos = decoded
        }
    }
}

struct TodoItem: Codable, Identifiable {
    var id = UUID()
    var title: String
    var isDone: Bool
}
