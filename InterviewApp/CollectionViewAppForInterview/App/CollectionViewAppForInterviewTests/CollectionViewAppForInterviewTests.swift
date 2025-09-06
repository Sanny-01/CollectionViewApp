//
//  CollectionViewAppForInterviewTests.swift
//  CollectionViewAppForInterviewTests
//
//  Created by sgiorgishvili on 01.09.25.
//

import Testing
@testable import CollectionViewAppForInterview

@MainActor
struct CollectionViewAppForInterviewViewModelTests {
    // MARK: - Components
    
    private var sut: ImageListViewModel!
    private var useCase: NASAImageUseCaseMock!
    private var coordinator: ImageListCoordinatorMock!
    
    // MARK: - Init
    
    init() {
        useCase = NASAImageUseCaseMock()
        coordinator = ImageListCoordinatorMock()
        sut = ImageListViewModel(imageUseCase: useCase, coordinator: coordinator)
    }
    
    // MARK: - Tests
    
    @Test
    func shouldSetItemsAndChangeStateToLoadedWhenFetchImageCallFinishes() async throws {
        useCase.fetchImagesPageSolReturnValue = getPhotos(count: 2)
        
        await sut.refresh()
        
        #expect(sut.state == .loaded)
        #expect(sut.items.count == 2)
        #expect(sut.canLoadMore == true)
    }
    
    @Test
    func shouldShouldLoadMoreWhenPageIndexIsCloseToTotalCountOfItems() async throws {
        let currentIndex = 6
        useCase.fetchImagesPageSolClosure = { _, _ in
            getPhotos(count: 10)
        }
        await sut.refresh()
        
        await sut.loadMoreIfNeeded(currentIndex: currentIndex)
        
        #expect(useCase.fetchImagesPageSolCallsCount == 2)
        #expect(sut.items.count == 20)
    }
    
    @Test
      func shouldShowErrorWhenFetchImageCallFails() async throws {
          useCase.fetchImagesPageSolClosure = { _, _ in
              throw CancellationError()
          }
          
          await sut.refresh()
          
          #expect(sut.state == .error(CancellationError().localizedDescription))
          #expect(sut.items.isEmpty)
      }
    
    @Test
    func shouldNavigateToDetailsWithCorrectDataWhenUserTapsImage() async throws {
        let expectedImageLink = "link-123"
        let expectedId = 1
        let expectedLandingDate = "2020-01-01"
        let expectedLaunchDate = "2019-01-01"
        let ExpectedName = "Curiosity"
        let expectedStatus = "active"
        
        sut.navigateToDetails(
            imageLink: "link-123",
            rover: RoverEntity(
                id: 1,
                name: "Curiosity",
                landingDate: "2020-01-01",
                launchDate: "2019-01-01",
                status: "active"
            )
        )
        
        #expect(coordinator.navigateToDetailsImageLinkRoverCalled == true)
        #expect(coordinator.navigateToDetailsImageLinkRoverReceivedArguments?.imageLink == expectedImageLink)
        #expect(coordinator.navigateToDetailsImageLinkRoverReceivedArguments?.rover.id == expectedId)
        #expect(coordinator.navigateToDetailsImageLinkRoverReceivedArguments?.rover.landingDate == expectedLandingDate)
        #expect(coordinator.navigateToDetailsImageLinkRoverReceivedArguments?.rover.launchDate == expectedLaunchDate)
        #expect(coordinator.navigateToDetailsImageLinkRoverReceivedArguments?.rover.name == ExpectedName)
        #expect(coordinator.navigateToDetailsImageLinkRoverReceivedArguments?.rover.status == expectedStatus)
    }
    
    // MARK: - Helpers
    
    func getPhotos(count: Int) -> MarsPhotosResponse {
        let photos = (0..<count).map {
            Photo(
                id: $0,
                sol: 1000,
                camera: Camera(id: 1, name: "CAM", roverID: 1, fullName: "Camera"),
                imgSrc: "link-\($0)",
                earthDate: "2020-01-01",
                rover: Rover(id: 1, name: "Curiosity", landingDate: "2020-01-01", launchDate: "2019-01-01", status: "active")
            )
        }
        return MarsPhotosResponse(photos: photos)
    }
}

// MARK: - Mocks

final class NASAImageUseCaseMock: NASAImageUseCase {
    var fetchImagesThrowableError: (any Error)?
    //MARK: - fetchImages
    var fetchImagesPageSolCallsCount = 0
    var fetchImagesPageSolCalled: Bool {
        fetchImagesPageSolCallsCount > 0
    }
    var fetchImagesPageSolReceivedArguments: (page: Int, sol: Int)?
    var fetchImagesPageSolReceivedInvocations: [(page: Int, sol: Int)] = []
    var fetchImagesPageSolReturnValue: MarsPhotosResponse!
    var fetchImagesPageSolClosure: ((Int, Int) async throws -> MarsPhotosResponse)?
    
    func fetchImages(page: Int, sol: Int) async throws -> MarsPhotosResponse {
        fetchImagesPageSolCallsCount += 1
        fetchImagesPageSolReceivedArguments = (page: page, sol: sol)
        fetchImagesPageSolReceivedInvocations.append((page: page, sol: sol))
        if let error = fetchImagesThrowableError {
            throw error
        }
        if let fetchImagesPageSolClosure = fetchImagesPageSolClosure {
            return try await fetchImagesPageSolClosure(page, sol)
        } else {
            return fetchImagesPageSolReturnValue
        }
    }
}

final class ImageListCoordinatorMock: ImageListCoordinator {
    //MARK: - start
    var startCallsCount = 0
    var startCalled: Bool {
        startCallsCount > 0
    }
    var startClosure: (() -> Void)?
    
    func start() {
        startCallsCount += 1
        startClosure?()
    }
    
    //MARK: - navigateToDetails
    var navigateToDetailsImageLinkRoverCallsCount = 0
    var navigateToDetailsImageLinkRoverCalled: Bool {
        navigateToDetailsImageLinkRoverCallsCount > 0
    }
    var navigateToDetailsImageLinkRoverReceivedArguments: (imageLink: String, rover: RoverEntity)?
    var navigateToDetailsImageLinkRoverReceivedInvocations: [(imageLink: String, rover: RoverEntity)] = []
    var navigateToDetailsImageLinkRoverClosure: ((String, RoverEntity) -> Void)?
    
    func navigateToDetails(imageLink: String, rover: RoverEntity) {
        navigateToDetailsImageLinkRoverCallsCount += 1
        navigateToDetailsImageLinkRoverReceivedArguments = (imageLink: imageLink, rover: rover)
        navigateToDetailsImageLinkRoverReceivedInvocations.append((imageLink: imageLink, rover: rover))
        navigateToDetailsImageLinkRoverClosure?(imageLink, rover)
    }
}
