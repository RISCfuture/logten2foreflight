import Foundation
@preconcurrency import GRDB
import LogTenToForeFlightMacros

@QueryObject
package struct Approach: Model, Identifiable, Equatable, Hashable {

    // MARK: Columns

    @QueryField(column: "Z_PK")
    package let id: Int64
    @QueryField(column: "ZAPPROACH_PLACE")
    package let placeID: Int64?
    @QueryField(column: "ZAPPROACH_TYPE", convert: { ApproachType(from: $0) })
    package let type: ApproachType?
    @QueryField(column: "ZAPPROACH_COMMENT")
    package let runway: String?
    @QueryField(column: "ZAPPROACH_QUANTITY")
    package let count: UInt?

    // MARK: Database configuration

    static package let databaseTableName = "ZAPPROACH"

    // MARK: Enumerations

    package enum ApproachType: String, RecordEnum {
        case GCA
        case GLS
        case GPS_GNSS = "GPS/GNSS"
        case IGS
        case ILS
        case JPALS
        case GBAS
        case LNAV
        case LNAV_VNAV = "LNAV/VNAV"
        case LPV
        case MLS
        case PAR
        case WAAS
        case ARA
        case contact = "CONTACT"
        case DME
        case GPS
        case IAN
        case LDA
        case LOC
        case LOC_BC = "LOC BC"
        case LOC_DME = "LOC/DME"
        case LP
        case NDB
        case RNAV
        case RNP
        case SDF
        case SRA
        case TACAN
        case visual = "VISUAL"
        case VOR
        case VOR_DME = "VOR/DME"
    }
}
