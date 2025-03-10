import Vapor
import Fluent
import struct Foundation.UUID

final class Rant: Model, @unchecked Sendable {
    static let schema = "rants"
    
    /// The id of this entity.
    @ID(key: .id)
    var id: UUID?
    
    /// The id of this rant.
    @Field(key: "rantId")
    var rantId: Int64
    
    /// The text contents of this rant.
    @Field(key: "text")
    var text: String
    
    init() { }
    
    init(rantId: Int64, text: String) {
        self.rantId = rantId
        self.text = text
    }
}

extension Rant {
    struct CodingData: Content {
        let id: Int64
        let text: String
        /*
        let score: Int
        let created_time: Int
        let attached_image: StringOrObjectDecodable<AttachedImage.CodingData>?
        let num_comments: Int
        let tags: [String]
        let vote_state: Int
        let edited: Bool
        let favorited: Int?
        let link: String?
        let links: [Link.CodingData]?
        let weekly: Weekly.CodingData?
        let c_type: Int?
        let c_type_long: String?
        let c_description: String?
        let c_tech_stack: String?
        let c_team_size: String?
        let c_url: String?
        let user_id: Int
        let user_username: String
        let user_score: Int
        let user_avatar: User.Avatar.CodingData
        let user_avatar_lg: User.Avatar.CodingData
        let user_dpp: Int?
         */
    }
}

extension Rant {
    var encoded: Rant.CodingData {
        .init(
            id: rantId,
            text: text
        )
    }
}

extension Rant.CodingData {
    var decoded: Rant {
        .init(
            rantId: id,
            text: text
        )
    }
}
