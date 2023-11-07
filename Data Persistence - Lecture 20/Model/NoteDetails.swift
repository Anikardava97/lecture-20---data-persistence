//
//  NoteDetails.swift
//  Data Persistence - Lecture 20
//
//  Created by Ani's Mac on 06.11.23.
//

import UIKit

struct NoteDetails {
    var title: String
    var description: String
    
    static let myNotes = [
        NoteDetails(
            title: "Shopping List",
            description: "Things to buy: groceries, supplies, and household items."
        ),
        
        NoteDetails(
            title: "Interesting Idea",
            description: "Innovative concepts for new personal or work-related projects."
        ),
        
        NoteDetails(
            title: "Weekly Goals",
            description: "Targets and objectives for the upcoming week's personal or professional growth."
        ),
        
        NoteDetails(
            title: "Creative Writing Prompts",
            description: "Ideas and prompts for stimulating creative writing exercises."
        ),
        
        NoteDetails(
            title: "Fitness Plan",
            description: "Exercise routines and diet plans for maintaining fitness and health."
        ),
        
        NoteDetails(
            title: "Meeting Agenda",
            description: "Items to discuss and address in upcoming meetings or presentations."
        ),
        
        NoteDetails(
            title: "Home Improvement",
            description: "Projects and tasks for home improvement and repairs."
        ),
    ]
}

