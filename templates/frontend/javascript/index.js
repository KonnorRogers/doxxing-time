import "index.css"
import * as Turbo from "@hotwired/turbo"
import { Application } from "@hotwired/stimulus"
import { setBasePath } from "@shoelace-style/shoelace/dist/utilities/base-path"
import "@shoelace-style/shoelace/dist/themes/light.css";
import "bridgetown-quick-search/dist";
import "konnors-pc"
import "@shoelace-style/shoelace/dist/components/button/button"
import "@shoelace-style/shoelace/dist/components/icon/icon"
import "@shoelace-style/shoelace/dist/components/icon-button/icon-button"
import "@shoelace-style/shoelace/dist/components/drawer/drawer"
import "@shoelace-style/shoelace/dist/components/visually-hidden/visually-hidden"

setBasePath("https://cdn.jsdelivr.net/npm/@shoelace-style/shoelace@2.0.0-beta.78/dist/")

// Uncomment the line below to add transition animations when Turbo navigates.
// We recommend adding <meta name="turbo-cache-control" content="no-preview" />
// to your HTML head if you turn on transitions. Use data-turbo-transition="false"
// on your <main> element for pages where you don't want any transition animation.
//
// import "./turbo_transitions.js"

// Import all JavaScript & CSS files from src/_components
import components from "bridgetownComponents/**/*.{js,jsx,js.rb,css}"

console.info("Bridgetown is loaded!")

window.Stimulus = Application.start()

import controllers from "./controllers/**/*.{js,js.rb}"
Object.entries(controllers).forEach(([filename, controller]) => {
  if (filename.includes("_controller.") || filename.includes("-controller.")) {
    const identifier = filename.replace("./controllers/", "")
      .replace(/[_-]controller..*$/, "")
      .replace("_", "-")
      .replace("/", "--")

    Stimulus.register(identifier, controller.default)
  }
})
