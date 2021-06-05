var path = require('path')

module.exports = {
    entry: { ChordSheet: "./index.js" },
    output: {
        path:  path.resolve(__dirname, 'dist'),
        filename: "[name].bundle.js",
        library: "[name]",
        libraryTarget: "var"
    },
	/*
	This bit below is how you make ChordSheetJS build properly, as it was getting errors:
	Discussion here: https://github.com/handlebars-lang/handlebars.js/issues/1174#issuecomment-229918935
	*/
	resolve: {
	    alias: {
	       handlebars: 'handlebars/dist/handlebars.min.js'
	    }
	} 
};