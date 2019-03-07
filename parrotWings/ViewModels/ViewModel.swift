//
//  ViewModel.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 07/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation

class ViewModel<TView> {
    public func configure(view: TView) -> Void {
        fatalError("You must implement configure in ViewModel!")
    }
}
