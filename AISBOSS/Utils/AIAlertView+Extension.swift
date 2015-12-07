//
// AIAlertView+Extension.swift
// AIVeris
//
// Created by admin on 12/4/15.
// Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import AIAlertView

extension AIAlertView {
	func showMessage(style: AIAlertViewStyle, onComfirm: Bool -> Void) {
        
	}
	func showMessageWithComfirm(onComfirm: Bool -> Void) {
		addButton("Cancel", target: self, selector: Selector("hideView"))

	}
}