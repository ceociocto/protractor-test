import { Config } from "protractor";

export let config: Config = {
    directConnect: true,
    specs: [
        "spec/**/*.spec.js"
    ],
    capabilities: {
        browserName: 'firefox',
      
        'moz:firefoxOptions': {
           args: [ "--headless" ]
         }
      }
}
