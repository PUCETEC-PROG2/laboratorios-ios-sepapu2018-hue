
//
// RepoList.swift
// GithubClient
//
// Created by Usuario invitado on 10/7/26.
//

import SwiftUI

struct RepoList: View {
    @StateObject private var viewController = RepoListViewController()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewController.isLoading {
                    ProgressView("Cargando repositorios...")
                } else if let error = viewController.errorMsg {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("Error al cargar repositorios")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Reintentar") {
                            Task {
                                await viewController.loadRepositories()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if viewController.repositories.isEmpty {
                    ContentUnavailableView(
                        "Sin repositorios",
                        systemImage: "folder.badge.minus",
                        description: Text("No se encontraron repositorios en la cuenta.")
                    )
                } else {
                    List(viewController.repositories) { repo in
                        RepoItem(repository: repo)
                    }
                }
            }
            .navigationTitle("Repositorios")
        }
        .onAppear {
            Task {
                await viewController.loadRepositories()
            }
        }
    }
}

#Preview {
    RepoList()
}
