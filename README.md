# Flutter Test Task – Product List App

A small Flutter application developed as part of a developer interview test task. It demonstrates 
clean architecture, reactive state management with MobX, offline support using SQLite, and modern 
UI design with GetWidget components.

## ✨ Key Features

- **Product Listing:** Displays a list of products with detailed info including price and specifications.
- **Offline Mode:** Supports offline usage by caching data locally with SQLite.
- **State Management:** Built with `MobX` for a clean, reactive architecture.
- **OOP & Inheritance:** Uses inheritance to structure product models and shared logic.
- **Custom UI with GetWidget:** Utilizes `GetWidget` components like accordions, cards, and buttons for consistent and reusable UI.

## 📁 Project Structure

lib/
├── core/ # App-wide models, constants, and utilities
├── screens/ # Screen-specific widgets and logic
├── widgets/ # Reusable UI components
└── main.dart # Application entry point

## 📌 Purpose
- This project was built to demonstrate:
- Proficiency in Flutter development
- Use of local persistence and state management
- Clean code architecture and reusable components

## How to run
To generate code for MobX state management and json serialization run in command line

`dart run build_runner build --delete-conflicting-outputs`

