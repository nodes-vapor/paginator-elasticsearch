import Elasticsearch
import Vapor
import Paginator

public protocol ElasticsearchQueryPaginatable {
    associatedtype ResultObject: Codable
    associatedtype PaginatableMetaData

    static func paginatedSearch<Document: Codable>(
        query: Query,
        on req: Request,
        using conn: ElasticsearchDatabase.Connection,
        decodeTo: Document.Type,
        indexName: String
    ) throws -> Future<([Document], PaginatableMetaData)>
}

public extension Query {
    public func paginatedSearch<P: Paginator, Document>(
        for req: Request,
        using conn: ElasticsearchDatabase.Connection,
        decodeTo: Document.Type,
        indexName: String
    ) throws -> Future<P> where
        P: ElasticsearchQueryPaginatable,
        P.Object == Document,
        P.ResultObject == Document,
        P.PaginatorMetaData == P.PaginatableMetaData
    {
        return try P.paginatedSearch(
            query: self,
            on: req,
            using: conn,
            decodeTo: decodeTo,
            indexName: indexName
        ).map { args -> P in
            let (results, data) = args
            return try P.init(data: results, meta: data)
        }
    }
}
