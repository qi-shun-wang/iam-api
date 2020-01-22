//
//  GroupPolicyPolicyController.swift
//  App
//
//  Created by GoFelis on 2020/1/22.
//

import Foundation
import Vapor

final class GroupPolicyController: RouteCollection {
    private let groupPolicyRepository: GroupPolicyRepository
    
    init(groupPolicyRepository: GroupPolicyRepository) {
        self.groupPolicyRepository = groupPolicyRepository
    }
    
    func boot(router: Router) throws {
        
    }
}
