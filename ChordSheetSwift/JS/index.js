import * as ChordSheetJS from 'chordsheetjs';

export class TextParser {
	static parseChordSheetToHTML(textFile) {

		// Make sure nativeLog is defined and is a function
		if (typeof nativeLog === 'function') {
			nativeLog(`Parsing Textfile to Song...`)
		}

		const parser = new ChordSheetJS.ChordSheetParser();
		const song = parser.parse(textFile);

		if (typeof nativeLog === 'function') {
			nativeLog(`Generating HTML from Song...`)
		}

		const formatter = new ChordSheetJS.HtmlDivFormatter();
		const disp = formatter.format(song);
		return disp
	}
	
	static cssTemplateForHTMLFormatter(scope) {
		const css = ChordSheetJS.HtmlDivFormatter.cssString(scope);
		return css
	}

	static parseUltimateGuitarToHTML(textFile) {

		// Make sure nativeLog is defined and is a function
		if (typeof nativeLog === 'function') {
			nativeLog(`Parsing Ultimate Guitar format to Song...`)
		}

		const parser = new ChordSheetJS.UltimateGuitarParser();
		const song = parser.parse(textFile);

		if (typeof nativeLog === 'function') {
			nativeLog(`Generating HTML from Song...`)
		}

		const formatter = new ChordSheetJS.HtmlDivFormatter();
		const disp = formatter.format(song);
		return disp
	}

	static parseChordProToHTML(textFile) {

		// Make sure nativeLog is defined and is a function
		if (typeof nativeLog === 'function') {
			nativeLog(`Parsing ChordPro to Song...`)
		}
		const parser = new ChordSheetJS.ChordProParser();
		const song = parser.parse(textFile);

		if (typeof nativeLog === 'function') {
			nativeLog(`Generating HTML from Song...`)
		}

		const formatter = new ChordSheetJS.HtmlDivFormatter();
		const disp = formatter.format(song);
		return disp
	}
};
