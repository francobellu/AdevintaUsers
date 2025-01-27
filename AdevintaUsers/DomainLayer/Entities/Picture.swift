struct Picture {
    let large: String
}

extension Picture: Identifiable, Hashable {
    var id: String { large }
}
