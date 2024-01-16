//
//  File.swift
//  MdEditorTests
//
//  Created by Alexey Turulin on 1/16/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest

// Жизненный цикл iOS приложения
final class TestCase: XCTestCase {
	
	override class func setUp() { // 1.
		// Это метод класса setUp().
		// Он вызывется перед началом первого тестового метода.
		// Установите здесь любое общее начальное состояние.
	}
	
	override func setUpWithError() throws { // 2.
		// Это метод экземпляра setUpWithError().
		// Он вызывается перед началом каждого тестового метода.
		// Настройте здесь любое состояние для каждого теста.
	}
	
	override func setUp() { // 3.
		// Это метод экземпляра setUp().
		// Он вызывается перед началом каждого тестового метода.
		// Используйте setupWithError() для установки любого состояния для каждого теста,
		// если у вас нет устаревших тестов, использующих setUp().
	}
	
	func testMethod1() throws { // 4.
		// Это первый тестовый метод.
		// Здесь находится ваш тестовый код.
		addTeardownBlock { // 5.
			// Вызывается, когда заканчивается testMethod1().
		}
	}
	
	func testMethod2() { // 6.
		// Это второй тестовый метод.
		// Здесь находится ваш тестовый код.
		addTeardownBlock { // 7.
			// Вызывается, когда заканчивается testMethod2().
		}
		
		addTeardownBlock { // 8.
			// Вызывается, когда заканчивается testMethod2().
		}
	}
	
	override func tearDown() { // 9.
		// Это метод экзмепляра tearDown().
		// Он вызывается после завершения каждого тестового метода.
		// Используйте tearDownWithError() для любой очистки для каждого теста,
		// если у вас нет устаревших тестов, использующих tearDown().
		super.tearDown()
	}
	
	override func tearDownWithError() throws { // 10.
		// Это метод экземпляра tearDownWithError().
		// Он вызывается после завершения каждого тестового метода.
		// Выполните здесь любую очистку для каждого теста.
		try super.tearDownWithError()
	}
	
	override class func tearDown() { // 11.
		// Это метод класса tearDown().
		// Он вызывается после завершения всех тестовых методов.
		// Выполните любую общую очистку здесь.
	}
}


