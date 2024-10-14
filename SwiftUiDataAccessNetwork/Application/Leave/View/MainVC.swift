//
//  MainVC.swift
//  SwiftUiDataAccessNetwork
//
//  Created by Hai Sombo on 10/14/24.
//

import SwiftUI

struct MainVC: View {
    
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        
        VStack {
            List(viewModel.leaves) { leave in
                VStack(alignment: .leading) {
                    Text(leave.user?.fullName ?? "Unknown User").font(.headline)
                    Text(leave.startDate ?? "No Start Date").font(.subheadline)
                    Text(leave.reason ?? "No Reason").font(.subheadline)
                }
            }
        }
        .navigationTitle("Leave List User")
        .onAppear {
            viewModel.fetchLeaves()
        }
    }
}

#Preview {
    MainVC()
}
