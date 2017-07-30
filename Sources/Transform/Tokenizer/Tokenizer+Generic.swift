/*
 Copyright 2017 Ryuichi Laboratories and the Yanagiba project contributors
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import AST

extension Tokenizer {
    open func generate(_ parameter: GenericParameterClause.GenericParameter, node: ASTNode) -> String {
        switch parameter {
        case let .identifier(t):
            return t
        case let .typeConformance(t, typeIdentifier):
            return "\(t): \(generate(typeIdentifier, node: node))"
        case let .protocolConformance(t, protocolCompositionType):
            return "\(t): \(generate(protocolCompositionType, node: node))"
        }
    }
    
    open func generate(_ clause: GenericParameterClause, node: ASTNode) -> String {
        return "<\(clause.parameterList.map { generate($0, node: node) }.joined(separator: ", "))>"
    }
    
    open func generate(_ clause: GenericWhereClause.Requirement, node: ASTNode) -> String {
        switch clause {
        case let .sameType(t, type):
            return "\(generate(t, node: node)) == \(generate(type, node: node))"
        case let .typeConformance(t, typeIdentifier):
            return "\(t.textDescription): \(typeIdentifier.textDescription)"
        case let .protocolConformance(t, protocolCompositionType):
            return "\(t.textDescription): \(protocolCompositionType.textDescription)"
        }
    }
    
    open func generate(_ clause: GenericWhereClause, node: ASTNode) -> String {
        return "where \(clause.requirementList.map { generate($0, node: node) }.joined(separator: ", "))"
    }
    
    // TODO: Review
    open func tokenize(_ clause: GenericArgumentClause, node: ASTNode) -> [Token] {
        return [clause.newToken(.identifier, generate(clause, node: node), node)]
    }
    open func generate(_ clause: GenericArgumentClause, node: ASTNode) -> String {
        return "<\(clause.argumentList.map { generate($0, node: node) }.joined(separator: ", "))>"
    }
}


extension GenericArgumentClause: ASTTokenizable {}