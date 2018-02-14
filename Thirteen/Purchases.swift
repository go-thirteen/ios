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
    
    func handlePurchase(_ state: IAPHandlerAlertType) {
        switch state {
        case .restored, .purchased:
            UserDefaults.standard.set(true, forKey: Keys.adsDisabled)
        default:
            break
        }
        purchaseHandler?(state)
    }
    
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
            handlePurchase(.disabled)
        }
    }
    
    func addSelf() {
        SKPaymentQueue.default().add(self)
    }
    
    func removeSelf() {
        SKPaymentQueue.default().remove(self)
    }
    
    func restorePurchase() {
        if self.canMakePurchases() {
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            handlePurchase(.disabled)
        }
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
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        handlePurchase(.failed(error))
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if (queue.transactions.count == 0) {
            let error = NSError(domain: "", code: 0, userInfo: ["localizedDescription":"No purchases to restore"])
            handlePurchase(.failed(error))
        } else {
            handlePurchase(.restored)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                handlePurchase(.purchased)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                handlePurchase(.failed(transaction.error))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                handlePurchase(.restored)
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
}
