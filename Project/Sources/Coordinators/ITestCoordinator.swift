//
//  ITestCoordinator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/2/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

protocol ITestCoordinator: AnyObject {
	func testStart(parameters: [LaunchArguments: Bool])
}
