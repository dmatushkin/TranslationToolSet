//
//  LanguageSelectionViewController.swift
//  TranslationToolSet
//
//  Created by Dmitry Matyushkin on 3/16/21.
//

import UIKit

protocol LanguageSelectionDelegate: class {
    func languageSelected(language: TranslationLanguage, forRow: Int)
}

class LanguageSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private var tableView: UITableView!
    weak var delegate: LanguageSelectionDelegate?
    var languages: [TranslationLanguage] = []
    var row: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageSelectionTableViewCell", for: indexPath) as? LanguageSelectionTableViewCell else { fatalError() }
        cell.setup(language: self.languages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.languageSelected(language: self.languages[indexPath.row], forRow: self.row)
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
