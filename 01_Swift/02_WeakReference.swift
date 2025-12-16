
/**
    Difference between weak and unowned
        weak - can be nil
        unowned - cannot be nil

        Check: 03_iOS_Core/01_RetainCycleDemo/RetainCycleDemo/HomeViewController.swift
*/

class Company {
    var employee: Employee?

    deinit {
        print("Company deinitialized")
    }
}

class Employee {
    var company: Company?

    deinit {
        print("Employee deinitialized")
    }
}

var company: Company? = Company()
var employee: Employee? = Employee()

company!.employee = employee
employee!.company = company

employee = nil
company = nil
