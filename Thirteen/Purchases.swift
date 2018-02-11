//
//  Purchases.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 2/11/18.
//  Copyright © 2018 Wilhelm Thieme. All rights reserved.
//

import UIKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    case failed
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        case .failed: return "Purchase Failed"
        }
    }
}

class Purchases: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private static let sharedInstance = Purchases()
    class func shared() -> Purchases {
        return self.sharedInstance
    }
    
    override init() {
        super.init()
        
        
    }
    
    
    var purchaseHandler: ((IAPHandlerAlertType) -> Void)?
    var productFetchedHandler: ((SKProduct) -> Void)?
    private var product = SKProduct()
    
    
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseProduct(){
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            purchaseHandler?(.disabled)
        }
    }
    
    
    func restorePurchase() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func fetchAvailableProducts() {
        let productIdentifiers = NSSet(objects: "com.wjthieme.thirteen")
        let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if let prod = response.products.first {
            productFetchedHandler?(prod)
            product = prod
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseHandler?(.restored)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseHandler?(.purchased)
                case .failed:
                    purchaseHandler?(.failed)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                default:
                    break
                }
            }
        }
    }
    
}
