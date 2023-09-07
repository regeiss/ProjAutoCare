//
//  HTTPClient.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 06/09/23.
//

import Foundation

protocol HTTPClientProtocol
{
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

class HTTPClient: NSObject
{
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer 26995ba0201c407da84ab37262254c9b"]
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    var basicAuthUserName: String = "default"
    var basicAuthPassword: String = "default"
    
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
    {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
    
        if endpoint.host == "newsapi.org"
        {
            urlComponents.queryItems = [URLQueryItem(name: "q", value: "COVID")]
        }
//        
//        if endpoint.host == "disease.sh"
//        {
//            urlComponents.queryItems = [URLQueryItem(name: "lastdays", value: "90")]
//        }
        
        print(urlComponents.url as Any)
        
        guard let url = urlComponents.url
        else
        {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let body = endpoint.body
        {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do
        {
            let (data, response) = try await session.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse
            else
            {
                return .failure(.noResponse)
            }
            
            switch response.statusCode
            {
            case 200...299:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                guard let decodedResponse = try? decoder.decode(responseModel, from: data)
                else
                {
                    return .failure(.decode)
                }

//                    print("Decode com sucesso")
//                    print(decodedResponse)
                  // session.finishTasksAndInvalidate()
                return .success(decodedResponse)

            case 401:
                // session.finishTasksAndInvalidate()
                return .failure(.unauthorized)

            default:
                // session.finishTasksAndInvalidate()
                return .failure(.unexpectedStatusCode)
            }
        }
        catch
        {
            return .failure(.unknown)
        }
    }
}

extension HTTPClient: URLSessionTaskDelegate
{
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodDefault ||
            challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic
        {
            
            let credential = URLCredential(user: self.basicAuthUserName,
                                           password: self.basicAuthPassword,
                                           persistence: .forSession)
            
            completionHandler(.useCredential, credential)
        }
        else
        {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
