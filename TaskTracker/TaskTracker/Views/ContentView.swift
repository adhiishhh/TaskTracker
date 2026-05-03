import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var tasks: [Task]
    @Environment(\.modelContext) private var modelContext

    @State private var newTaskTitle: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Add task row
                HStack(spacing: 10) {
                    TextField("New Task", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit { addTask() }

                    Button("Add") {
                        addTask()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()

                // Task list
                List {
                    ForEach(tasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.seal.fill" : "circle.badge")
                                .foregroundStyle(task.isCompleted ? .green : .secondary)
                                .font(.title3)

                            Text(task.title)
                                .strikethrough(task.isCompleted)
                                .foregroundStyle(task.isCompleted ? .secondary : .primary)

                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleTask(task)
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Task Tracker")
        }
    }

    private func addTask() {
        let title = newTaskTitle.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else { return }
        let newTask = Task(title: title)
        modelContext.insert(newTask)
        newTaskTitle = ""
    }

    private func toggleTask(_ task: Task) {
        task.isCompleted.toggle()
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tasks[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, inMemory: true)
}
