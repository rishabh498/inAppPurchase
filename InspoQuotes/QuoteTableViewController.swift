
import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver{
    
    let ProdID = "HEllO"
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        if isPurchased(){
            showPremQUOTES()
        }
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isPurchased(){
            return quotesToShow.count
        }
        else{
        return quotesToShow.count + 1
        }
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        if indexPath.row < quotesToShow.count{
        cell.textLabel?.text = quotesToShow[indexPath.row]
        cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        }
        else{
            cell.textLabel?.text = "Buy more Quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.4152754353, blue: 1, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count{
            buyPremiun()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MArk: In app purchases
    
    func buyPremiun(){
        
        if SKPaymentQueue.canMakePayments(){
            
            let pay = SKMutablePayment()
            pay.productIdentifier = ProdID
            SKPaymentQueue.default().add(pay)
            
        }
        else{
            //cant make payments
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for trans in transactions{
            if trans.transactionState == .purchased{
                //release quotes
                SKPaymentQueue.default().finishTransaction(trans)
                showPremQUOTES()
                
                UserDefaults.standard.set(true, forKey: "prodID")
            }
            else if trans.transactionState == .failed{
                //payment failed
                if let err = trans.error{
                    let errDes = err.localizedDescription
                    print("Transaction failed due to error: \(errDes)")
                }
                SKPaymentQueue.default().finishTransaction(trans)
            }
            else if trans.transactionState == .restored{
                showPremQUOTES()
                SKPaymentQueue.default().finishTransaction(trans)
                navigationItem.setRightBarButton(nil, animated: true)
            }
        }
    }

    func showPremQUOTES(){
        UserDefaults.standard.set(true, forKey: "prodID")
        quotesToShow.append(contentsOf: premiumQuotes)
        self.tableView.reloadData()
    }
    
    func isPurchased() -> Bool{
        let purchase = UserDefaults.standard.bool(forKey: "prodID")
        if purchase{
            return true
        }
        else{
            return false
        }
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }


}
