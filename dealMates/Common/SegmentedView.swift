//
//  SegmentedView.swift
//  dealMates
//
//  Created by Stanislav Kutsenko on 01.02.2022.
//

import UIKit

protocol SegmentedViewDelegate: AnyObject {
    func segmentedView(_ segmentedView: SegmentedView, didChangeSelectedSegmentAt index: Int)
}

class SegmentedView: UIView {
    
    weak var delegate: SegmentedViewDelegate?
    
    lazy var selectorView = UIView()
    lazy var labels = [UILabel]()
    private var titles: [String] = []
    var textColor = AppColor.any_132_134_137()
    var selectorTextColor = AppColor.black()
    public private(set) var selectedIndex: Int = 0

    var isViewSetup = false
    
    convenience init(frame: CGRect, titles: [String]) {
        self.init(frame: frame)
        self.titles = titles
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        setupUI()
    }
}
// MARK: - Public
extension SegmentedView {
    func setLabelsTitles(titles: [String]) {
        self.titles = titles
        self.setupUI()
    }
    
    func select(module: Int) {
        guard module < titles.count else { return }
        
        for (labelIndex, label) in labels.enumerated() {
            
            if module == labelIndex {
                let selectorPosition = frame.width / CGFloat(titles.count) * CGFloat(labelIndex)
                selectedIndex = module
                delegate?.segmentedView(self, didChangeSelectedSegmentAt: selectedIndex)
                UIView.animate(withDuration: 0.1) {
                    self.selectorView.frame.origin.x = selectorPosition
                    label.textColor = self.selectorTextColor
                }
                labels[module].textColor = self.selectorTextColor
            } else {
                UIView.animate(withDuration: 0.1) {
                    label.textColor = self.textColor
                }
            }
        }
    }
}

// MARK: - Private
private extension SegmentedView {
    
    func setupUI() {
        createLabels()
        setupSelectorView()
        setupStackView()
    }
    
    func createLabels() {
        
        labels.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for labelTitle in titles {
            
            let label = UILabel()
            label.font = .handoSoft(size: 16, weight: .bold) // need sf pro
            label.text = labelTitle
            
            let tapGestureRecognizor = UITapGestureRecognizer(target: self, action: #selector(labelActionHandler(sender:)))
            tapGestureRecognizor.numberOfTapsRequired = 1
            label.addGestureRecognizer(tapGestureRecognizor)
            label.isUserInteractionEnabled = true
            
            label.textColor = textColor
            label.textAlignment = .center
            labels.append(label)
        }
        labels[selectedIndex].textColor = selectorTextColor
    }
    
    func setupStackView() {
        
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    func setupSelectorView() {
        let segmentsCount = CGFloat(titles.count)
        let selectorWidth = self.frame.width / segmentsCount
        let selectorX = frame.width / CGFloat(titles.count) * CGFloat(selectedIndex)
        selectorView = UIView(frame: CGRect(x: selectorX, y: self.frame.height - 1.0, width: selectorWidth, height: 1.0))
        selectorView.backgroundColor = selectorTextColor
        addSubview(selectorView)
    }
}

// MARK: - Private Actions
private extension SegmentedView {
    
    @objc func labelActionHandler(sender: UITapGestureRecognizer) {
        
        for (labelIndex, label) in labels.enumerated() {
            
            if label == sender.view {
                let selectorPosition = frame.width / CGFloat(titles.count) * CGFloat(labelIndex)
                selectedIndex = labelIndex
                delegate?.segmentedView(self, didChangeSelectedSegmentAt: selectedIndex)
                UIView.animate(withDuration: 0.1) {
                    self.selectorView.frame.origin.x = selectorPosition
                    label.textColor = self.selectorTextColor
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    label.textColor = self.textColor
                }
            }
        }
    }
}

