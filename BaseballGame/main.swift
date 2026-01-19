//
//  main.swift
//  BaseballGame
//
//  Created by ios on 1/14/26.
//

//import Foundation

//print("Hello, World!")

//LV1
/*
var randomNumber : Set<Int> = []
// var randomNumber = Set<Int>()로 표현해도된다.
var answerNumber: [Int] = []

while randomNumber.count < 3 {
    let num = Int.random(in:1...9)
    randomNumber.insert(num)
}
?
answerNumber = randomNumber.map{$0}
print(answerNumber)
*/



/* 각 클래스별로 기능 나누기
 - 정답 클래스 만들기
 - Input 클래스 만들기
 - 힌트 클래스 만들기 ( 스트라이크와 볼 구분)
 - baseballGame 클래스 만들기 ( 전체적인 관리, 각 클래스의 메서드 호출)
 ---------------------------------------------------------
 - 에러코드 enum으로 만들기
 
 */

import Foundation

// 정답 class - 정답을 랜덤으로 생성
class AnswerGenerator {
    func generate() -> [Int] {
        var numbers = Set<Int>()
        while numbers.count < 3 {
            let number = Int.random(in: 1...9)
            numbers.insert(number)
        }
        return Array(numbers)
    }
}

// error 별로 나누기
enum InputError: Error {
    case emptyInput
    case notANumber
    case numLimit
    case duplicated
}

// Intput class - 입력값을 받고 3자리가 맞는지 숫자인지 확인한다.
class InputHandler {
    func getInput() throws -> String {
        print("ㄴ ", terminator: "")

        guard let input = readLine() else {
            throw InputError.emptyInput
        }

        guard !input.isEmpty else {
            throw InputError.emptyInput
        }

        guard Int(input) != nil else {
            throw InputError.notANumber
        }

        guard let number = Int(input), 100...999 ~= number else {
            throw InputError.numLimit
        }

        guard Set(input).count == 3 else {
            throw InputError.duplicated
        }

        return input
    }
}

// 힌트 class
class HintCalculator {
    func calculateHints(answer: [Int], userGuess: [Int]) -> (strike: Int, ball: Int) {
        let strikeCount = zip(answer, userGuess)
            .map { $0 == $1 ? 1 : 0 }
            .reduce(0, +)

        let ballCount = userGuess.filter { answer.contains($0) }.count - strikeCount
        return (strikeCount, ballCount)
    }
}

// BaseballGame 클래스
class BaseballGame {
    private let answerGenerator = AnswerGenerator()
    private let inputHandler = InputHandler()
    private let hintCalculator = HintCalculator()
    private var gameRecords: [Int] = []   // 시도 횟수 기록

    // LV4. 안내문구 출력 (메뉴)
    func first() {
        while true {
            print("""
            환영합니다
            원하시는 번호를 입력해주세요
            1. 게임 시작하기
            2. 게임 기록보기
            3. 종료하기
            """)

            guard let input = readLine(), let menu = Int(input) else {
                print("입력이 잘못됐습니다. 다시 입력해주세요")
                continue
            }

            switch menu {
            case 1:
                start()
            case 2:
                record()
            case 3:
                print("숫자 야구게임을 종료합니다.")
                return   // while + 함수 종료
            default:
                print("입력이 잘못됐습니다. 다시 입력해주세요")
            }
        }
    }

    // 게임 기록 보기
    func record() {

        if gameRecords.isEmpty {
            print("아직 게임 기록이 없습니다.")
            return
        }
        for (index, tries) in gameRecords.enumerated() {
            print("\(index + 1)번째 게임: 시도 횟수 \(tries)번")
        }
    }
    
    /*2를 눌러도 기록은 안보인다..*/

    // 게임 시작 함수
    func start() {
        let answer = answerGenerator.generate()
        print("⚾️ 숫자 야구 게임 시작합니다 세 자리 숫자를 입력하세요! ⚾️")

        var tryCount = 0

        while true {
            do {
                let userInput = try inputHandler.getInput()
                let userGuess = userInput.compactMap { Int(String($0)) }

                

                let (strike, ball) = hintCalculator.calculateHints(answer: answer, userGuess: userGuess)
                print("\(strike) 스트라이크, \(ball) 볼")

                if strike == 3 {
                    print("!!!!!!홈런!!!!!!!")
                    tryCount += 1
                    gameRecords.append(tryCount) //  기록 저장
                    break
                } else {
                    print("아쉽지만 다시")
                }

            } catch InputError.emptyInput {
                print("아무것도 입력하지 않으셨습니다.")
            } catch InputError.notANumber {
                print("숫자가 아닙니다.")
            } catch InputError.numLimit {
                print("세 자리 숫자를 입력해주세요.")
            } catch InputError.duplicated {
                print("숫자 중복 없이 입력해주세요.")
            } catch {
                print("알 수 없는 오류가 발생했습니다.")
            }
        }
    }
}

// 실행
let game = BaseballGame()
game.first()   //

