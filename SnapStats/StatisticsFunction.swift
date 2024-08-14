//
//  StatisticsFunction.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/16/24.
//

import Foundation


func getFG(game: Game, id: UUID) -> String {
    let total = game.userPlayerBoxStats[id]!.P2A + game.userPlayerBoxStats[id]!.P3A
    let made = game.userPlayerBoxStats[id]!.P2M + game.userPlayerBoxStats[id]!.P3M
    return made.description + "-" + total.description
}

func get3PTFG(game: Game, id: UUID) -> String {
    let total = game.userPlayerBoxStats[id]!.P3A
    let made = game.userPlayerBoxStats[id]!.P3M
    return made.description + "-" + total.description
}

func getFTFG(game: Game, id: UUID) -> String {
    let total = game.userPlayerBoxStats[id]!.FTA
    let made = game.userPlayerBoxStats[id]!.FTM
    return made.description + "-" + total.description
}

func getPlayerPointsInGame(game: Game, id: UUID) -> Int {
    var points = 0
    if let player = game.userPlayerBoxStats[id] {
        if let p1m = game.userPlayerBoxStats[id]?.FTM {
            points += p1m
        }
        if let p2m = game.userPlayerBoxStats[id]?.P2M {
            points += p2m * 2
        }
        if let p3m = game.userPlayerBoxStats[id]?.P3M {
            points += p3m * 3
        }
    }
    return points
}

func getPlayerReboundsInGame(game: Game, id: UUID) -> Int {
    var rebounds = 0
    if let player = game.userPlayerBoxStats[id] {
        if let dreb = game.userPlayerBoxStats[id]?.DREB {
            rebounds +=  dreb
        }
        if let oreb = game.userPlayerBoxStats[id]?.OREB {
            rebounds +=  oreb
        }
    }
    return rebounds
}


func getTotalPlayerPoints(team: TeamModel, player: Player) -> Int {
    var points = 0
    for game in team.games {
        if let p2m = game.userPlayerBoxStats[player.id]?.P2M {
            points += p2m * 2
        }
        if let p3m = game.userPlayerBoxStats[player.id]?.P3M {
            points += p3m * 3
        }
    }
    return points
}

func getTeamsStatSingleGame(game: Game, team: TeamModel, statName: String) -> Int {
    var stat = 0
    for player in team.players {
        if let pl = game.userPlayerBoxStats[player.id] {
            if statName == "PTS" {
                stat += getPlayerPointsInGame(game: game, id: player.id)
            } else if statName == "AST" {
                stat += pl.AST
            } else if statName == "DREB" {
                stat += pl.DREB
            } else if statName == "OREB" {
                stat += pl.OREB
            } else if statName == "STL" {
                stat += pl.STL
            } else if statName == "BLK" {
                stat += pl.BLK
            } else if statName == "TOV" {
                stat += pl.TOV
            }
        }
    }
    
    return stat
}

func getTeamFG(game: Game, team: TeamModel) -> (String, Double) {
    var made = 0
    var total = 0
    for player in team.players {
        let id = player.id
        if let player = game.userPlayerBoxStats[id] {
            total += player.P2A + player.P3A
            made += player.P2M + player.P3M
        }
    }
    
    return (made.description + "-" + total.description, Double(made)/Double(total))
}

func getTeam3PT(game: Game, team: TeamModel) -> (String, Double) {
    var made = 0
    var total = 0
    for player in team.players {
        let id = player.id
        if let player = game.userPlayerBoxStats[id]{
            total += player.P3A
            made += player.P3M
        }
    }
    
    return (made.description + "-" + total.description, (Double(made)/Double(total)))
}

func getTeamFTFG(game: Game, team: TeamModel) -> (String, Double) {
    var made = 0
    var total = 0
    for player in team.players {
        let id = player.id
        if let player = game.userPlayerBoxStats[id]{
            total += player.FTA
            made += player.FTM
        }
    }
    
    return (made.description + "-" + total.description, Double(made)/Double(total))
}

extension TeamModel {
    func getPlayerAverageInStat(stat: String, id: UUID) -> Double {
        var sum = 0
        for game in games {
            if let user = game.userPlayerBoxStats[id] {
                if stat == "PTS" {
                    sum += getPlayerPointsInGame(game: game, id: id)
                } else if stat == "AST" {
                    sum += user.AST
                } else if stat == "REB" {
                    sum += getPlayerReboundsInGame(game: game, id: id)
                } else if stat == "BLK" {
                    sum += user.BLK
                } else if stat == "STL" {
                    sum += user.STL
                } else if stat == "OREB" {
                    sum += user.OREB
                } else if stat == "DREB" {
                    sum += user.DREB
                }
            }
            
        }
        
        if games.count < 1 {
            return 0.0
        } else {
            return Double(sum) / Double(games.count)
        }
    }
    
    func getTeamAverageInStat(stat: String) -> Double {
        var sum = 0
        for game in games {
            sum += getTeamsStatSingleGame(game: game, team: self, statName: stat)
        }
        
        if games.count < 1 {
            return 0.0
        } else {
            return Double(sum) / Double(games.count)
        }
    }
    
    private func getPlayerShootingTotals(stat: String, id: UUID) -> Int {
        var sum = 0
        for game in games {
            if let player = game.userPlayerBoxStats[id] {
                if stat == "FGM" {
                    sum += player.P2M + player.P3M
                } else if stat == "FGA" {
                    sum += player.P2A + player.P3A
                } else if stat == "3PM" {
                    sum += (player.P3M)
                } else if stat == "3PA" {
                    sum += player.P3A
                } else if stat == "FTM" {
                    sum += player.FTM
                } else if stat == "FTA" {
                    sum += player.FTA
                } else if stat == "2PM" {
                    sum += player.P2M
                } else if stat == "2PA" {
                    sum += player.P2A
                }
            }
        }
        return sum
    }
    
    func getPlayerShootingStatAverage(stat: String, id: UUID) -> Double {
        var total = 0.0
        if !stat.contains(where: {$0 == "%"}) {
            total = Double(getPlayerShootingTotals(stat: stat, id: id))
        } else {
            if stat == "FG%" {
                total +=  Double(getPlayerShootingTotals(stat: "FGM", id: id)) / Double(getPlayerShootingTotals(stat: "FGA", id: id))
            } else if stat == "FT%" {
                total +=  Double(getPlayerShootingTotals(stat: "FTM", id: id)) / Double(getPlayerShootingTotals(stat: "FTA", id: id))
            } else if stat == "2P%"{
                total +=  Double(getPlayerShootingTotals(stat: "2PM", id: id)) / Double(getPlayerShootingTotals(stat: "2PA", id: id))
            } else if stat == "2P%"{
                total += Double(getPlayerShootingTotals(stat: "3PM", id: id)) / Double(getPlayerShootingTotals(stat: "3PA", id: id))
            }
        }
        
        
        if games.count < 1 {
            return total
        } else {
            return total / Double(games.count)
        }
     }
    
}

func calculateStatLeader(stat: String, team: TeamModel) -> (Double, Player) {
    var highest = 0.0
    let firstPlayer: Player = team.players.first!
    
    for player in team.players {
        let id = player.id
        let curr = team.getPlayerAverageInStat(stat: stat, id: id)
        if curr > highest {
            highest = curr
        }
    }
    return (highest, firstPlayer)
}

extension Game {
    func getPlayerPointsInGame(id: UUID) -> Int {
        if let player = self.userPlayerBoxStats[id] {
            return player.P2M * 2 + player.P3M * 3 + player.FTM
        } else {
            return 0
        }
    }
    
    
    func getPlayerStatInGame(stat: BasketballStat, id: UUID) -> Int {
        var val = 0
        
        if let player = self.userPlayerBoxStats[id] {
            switch stat {
            case .PTS:
                val = player.P2M * 2 + player.P3M * 3 + player.FTM
            case .AST:
                val = player.AST
            case .REB:
                val = player.DREB + player.OREB
            case .OREB:
                val = player.OREB
            case .DREB:
                val = player.DREB
            case .STL:
                val = player.STL
            case .BLK:
                val = player.BLK
            case .TOV:
                val = player.TOV
            }
        }
        
        return val
    }
}

enum BasketballStat: String, CaseIterable{
    case PTS, AST, REB, OREB, DREB, STL, BLK, TOV
    
    static var firstThree: [BasketballStat] {
        return [.PTS, .AST, .REB]
    }
}


