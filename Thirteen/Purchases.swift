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
    case failed(Error?)
    
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
    var product: SKProduct?
    
    
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseProduct() {
        guard let product = product else {
            self.fetchAvailableProducts()
            return
        }
        
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            purchaseHandler?(.disabled)
        }
    }
    
    func addSelf() {
        SKPaymentQueue.default().add(self)
    }
    
    func removeSelf() {
        SKPaymentQueue.default().remove(self)
    }
    
    
    func restorePurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func fetchAvailableProducts() {
        let productsRequest = SKProductsRequest(productIdentifiers: ["com.wjthieme.thirteen"])
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
                    SKPaymentQueue.default().finishTransaction(trans)
                    purchaseHandler?(.purchased)
                case .failed:
                    purchaseHandler?(.failed(trans.error))
                    SKPaymentQueue.default().finishTransaction(trans)
                case .restored:
                    purchaseHandler?(.restored)
                    SKPaymentQueue.default().finishTransaction(trans)
                default:
                    break
                }
            }
        }
    }
    
}
