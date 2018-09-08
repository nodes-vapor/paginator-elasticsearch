import Elasticsearch
import Vapor
import Paginator

extension OffsetPaginator: ElasticsearchQueryPaginatable where Object: Codable {
    public static func paginatedSearch<Document: Codable>(
        query: Elasticsearch.Query,
        on req: Request,
        using conn: ElasticsearchDatabase.Connection,
        decodeTo: Document.Type,
        indexName: String
    ) throws -> Future<([Document], OffsetMetaData)> {
        let config: OffsetPaginatorConfig = (try? req.make()) ?? .default

        return try OffsetQueryParams.decode(req: req)
            .flatMap { params in
                let page = params.page ?? config.defaultPage
                let perPage = params.perPage ?? config.perPage
                let lower = (page - 1) * perPage
                
                let searchContainer = SearchContainer(query, from: lower, size: perPage)

                let results = try conn.search(
                    decodeTo: Document.self,
                    index: indexName,
                    query: searchContainer
                )
                
                return results.map { searchResponse in
                    let documents = searchResponse.hits?.hits.map { $0.source }
                    let count = searchResponse.hits?.total ?? 0

                    let data = try OffsetMetaData(
                        currentPage: page,
                        perPage: perPage,
                        total: count,
                        on: req
                    )
                    return (documents ?? [], data)
                }
            }
    }
}
