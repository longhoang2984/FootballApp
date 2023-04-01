//
//  TeamLogoViewModel.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation
import Combine

public struct TeamLogoModel<Img> {
    public let image: Img?
    public let isLoading: Bool
    public let url: URL
    
    public init(image: Img?,
                isLoading: Bool,
                url: URL) {
        self.image = image
        self.isLoading = isLoading
        self.url = url
    }
}

public protocol TeamLogoView {
    associatedtype Img
    
    func display(_ model: TeamLogoModel<Img>)
}

public final class TeamLogoViewModel<View: TeamLogoView, Img> where View.Img == Img {
    public typealias Mapper = (Data) throws -> View.Img?
    private let view: View
    private let mapper: Mapper
    
    public init(view: View,
                mapper: @escaping Mapper) {
        self.view = view
        self.mapper = mapper
    }
    
    public func didStartLoadingImageData(url: URL) {
        view.display(TeamLogoModel(image: nil,
                                        isLoading: true,
                                    url: url))
    }
    
    public func didFinishLoadingImageData(with data: Data, url: URL) {
        guard let img = try? mapper(data) else { return }
        view.display(TeamLogoModel(image: img,
                                        isLoading: false, url: url))
    }
    
    public func didFinishLoadingImageData(with error: Error, url: URL) {
        view.display(TeamLogoModel(image: nil,
                                        isLoading: false, url: url))
    }
}
