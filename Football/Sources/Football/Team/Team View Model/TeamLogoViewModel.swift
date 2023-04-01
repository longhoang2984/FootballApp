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
    
    public init(image: Img?, isLoading: Bool) {
        self.image = image
        self.isLoading = isLoading
    }
}

public final class TeamLogoViewModel<Img> {
    public enum Input {
        case requestImage
        case cancelImage
        case showImageData(Data)
        case showError(Error)
    }
    
    public enum Output {
        case display(TeamLogoModel<Img>)
    }
    
    public typealias Mapper = (Data) throws -> Img?
    private let mapper: Mapper
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    public let input = PassthroughSubject<TeamLogoViewModel<Img>.Input, Never>()
    
    public init(mapper: @escaping Mapper) {
        self.mapper = mapper
    }
    
    public func transform() -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .requestImage:
                self.output.send(.display(TeamLogoModel(image: nil,
                                                        isLoading: true)))
            case let .showImageData(data):
                guard let img = try? self.mapper(data) else { return }
                self.output.send(.display(TeamLogoModel(image: img,
                                                        isLoading: false)))
            case .cancelImage:
                self.cancellables.forEach { $0.cancel() }
            case .showError:
                self.output.send(.display(TeamLogoModel(image: nil,
                                                        isLoading: false)))
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
