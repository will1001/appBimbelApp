import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tex/flutter_tex.dart';
// import 'package:bimbel_app_final/model/Globals.dart' as globals;

class LatexMethods {
  String _baseUrl = "https://fisikamu.xyz";

  List siunitX1 = [
    {"code": r'\watt\per\meter\squared', "translation": r'W/m^2'},
    {
      "code": r'\joule\per\second\per\meter\squared',
      "translation": r'Js^{-1} m^{-2}'
    },
    {"code": r'\decibel', "translation": r'dB'},
    {"code": r'\joule\coulomb', "translation": r'J/C'},
    {
      "code": r'\newton\meter\squared\per\coulomb\squared',
      "translation": r'Nm^2 C^{-2}'
    },
    {
      "code": r'\kilogram\meter\cubed\per\coulomb\squared\per\second\squared',
      "translation": r'kgm^3 C^{-2} s^{-2}'
    },
    {
      "code": r'\newton\meter\squared\per\kilogram\squared',
      "translation": r'Nm^2 kg^{-2}'
    },
    {
      "code": r'\meter\cubed\per\kilogram\per\second\squared',
      "translation": r'm^3 kg^{-1} s^{-2}'
    },
    {"code": r'\gram\per\centi\meter\squared', "translation": r'g/cm^2'},
    {"code": r'\kilogram\per\meter\squared', "translation": r'kg/m^2'},
    {"code": r'\kilogram\per\meter\squared', "translation": r'kg/m^2'},
    {"code": r'\gram\per\centi\meter', "translation": r'g/cm'},
    {"code": r'\kilogram\per\meter', "translation": r'kg/m'},
    {"code": r'\newton', "translation": r'N'},
    {"code": r'\joule\per\kelvin', "translation": r'J/K'},
    {"code": r'\joule\per\celsius', "translation": r'J/\degree{C}'},
    {"code": r'\joule\per\kilogram\per\kelvin', "translation": r'J/kgK'},
    {
      "code": r'\joule\per\kilogram\per\celsius',
      "translation": r'J/kg\degree{C}'
    },
    {"code": r'\per\celcius', "translation": r'/\degree{C}'},
    {"code": r'\per\kelvin', "translation": r'/K'},
    {"code": r'\tesla\meter\squared', "translation": r'T m^2'},
    {"code": r'\weber', "translation": r'Wb'},
    {"code": r'\weber\per\meter\squared', "translation": r'Wb/m^2'},
    {"code": r'\mega\tesla', "translation": r'MT'},
    {"code": r'\kilo\tesla', "translation": r'kT'},
    {"code": r'\kilo\tesla', "translation": r'kT'},
    {"code": r'\nano\tesla', "translation": r'nT'},
    {"code": r'\micro\tesla', "translation": r'\mu{T}'},
    {"code": r'\milli\tesla', "translation": r'mT'},
    {"code": r'\tesla', "translation": r'T'},
    {"code": r'\pico\coulomb', "translation": r'pC'},
    {"code": r'\nano\coulomb', "translation": r'nC'},
    {"code": r'\milli\coulomb', "translation": r'mC'},
    {"code": r'\micro\coulomb', "translation": r'\mu{C}'},
    {"code": r'\coulomb', "translation": r'C'},
    {"code": r'\volt\ampere', "translation": r'VA'},
    {"code": r'\mega\watt', "translation": r'MW'},
    {"code": r'\kilo\watt', "translation": r'kW'},
    {"code": r'\watt', "translation": r'W'},
    {"code": r'\joule\per\second', "translation": r'J/s'},
    {
      "code": r'\kilogram\per\meter\per\second\squared',
      "translation": r'kg m^{-1}s^{-2}'
    },
    {"code": r'\kilo\bar', "translation": r'kbar'},
    {"code": r'\bar', "translation": r'bar'},
    {"code": r'\kilo\pascal', "translation": r'kPa'},
    {"code": r'\mega\pascal', "translation": r'MPa'},
    {"code": r'\pascal', "translation": r'Pa'},
    {"code": r'\newton\per\centi\meter\squared', "translation": r'N cm^{-2}'},
    {"code": r'\newton\per\meter\squared', "translation": r'Nm^{-2}'},
    {"code": r'\kilogram\meter\squared', "translation": r'kg m^2'},
    {"code": r'\newton\meter', "translation": r'N m'},
    {"code": r'\newton\second', "translation": r'N s'},
    {"code": r'\mega\electronvolt', "translation": r'MeV'},
    {"code": r'\kilo\electronvolt', "translation": r'keV'},
    {"code": r'\electronvolt', "translation": r'eV'},
    {"code": r'\kilo\watt\hour', "translation": r'kWh'},
    {"code": r'\watt\hour', "translation": r'Wh'},
    {"code": r'\watt\second', "translation": r'Ws'},
    {
      "code": r'\kilogram\meter\squared\per\second\squared',
      "translation": r'kgm^2s^{-2}'
    },
    {"code": r'\mega\joule', "translation": r'MJ'},
    {"code": r'\kilo\joule', "translation": r'kJ'},
    {
      "code": r'\kilogram\meter\squared\radian\per\second',
      "translation": r'kg m^2rad/s'
    },
    {
      "code": r'\kilogram\meter\squared\radian\per\second',
      "translation": r'kg m^2rad/s'
    },
    {"code": r'\gram\kilo\meter\per\hour', "translation": r'g km/jam'},
    {"code": r'\kilogram\kilo\meter\per\hour', "translation": r'kg km/jam'},
    {"code": r'\kilogram\kilo\meter\per\hour', "translation": r'kg km/jam'},
    {"code": r'\gram\meter\per\second', "translation": r'g m/s'},
    {"code": r'\kilogram\meter\per\second', "translation": r'kgm/s'},
    {
      "code": r'\newton\meter\squared\per\kilogram\squared',
      "translation": r'N m^2kg^{-2}'
    },
    {"code": r'\pascal\meter\squared', "translation": r'Pam^2'},
    {"code": r'\kilogram\meter\per\second\squared', "translation": r'kg m/s^2'},
    {"code": r'\radian\per\second\squared', "translation": r'rad/s^2'},
    {"code": r'\newton\per\kilogram', "translation": r'N/kg'},
    {"code": r'\kilo\meter\per\minute', "translation": r'km/min'},
    {"code": r'\kilo\meter\per\second', "translation": r'km/s'},
    {"code": r'\meter\per\minute', "translation": r'm/min'},
    {"code": r'\radian\per\minute', "translation": r'rad/min'},
    {"code": r'\kilo\meter\per\hour', "translation": r'km/jam'},
    {"code": r'\radian\per\second', "translation": r'rad/s'},
    {"code": r'\per\minute', "translation": r'min^{-1}'},
    {"code": r'\per\second', "translation": r's^{-1}'},
    {"code": r'\milli\hertz', "translation": r'mHz'},
    {"code": r'\tera\hertz', "translation": r'THz'},
    {"code": r'\giga\hertz', "translation": r'GHz'},
    {"code": r'\mega\hertz', "translation": r'MHz'},
    {"code": r'\kilo\hertz', "translation": r'kHz'},
    {"code": r'\centi\liter', "translation": r'cL'},
    {"code": r'\milli\liter', "translation": r'mL'},
    {"code": r'\liter', "translation": r'L'},
    {"code": r'\hectare', "translation": r'ha'},
    {"code": r'\milli\meter\squared', "translation": r'mm^2'},
    {"code": r'\centi\meter\squared', "translation": r'cm^2'},
    {"code": r'\candela', "translation": r'cd'},
    {"code": r'\mole', "translation": r'mol'},
    {"code": r'\minute', "translation": r'min'},
    {"code": r'\hour', "translation": r'h'},
    {"code": r'\nano\second', "translation": r'ns'},
    {"code": r'\micro\second', "translation": r'\mu{s}'},
    {"code": r'\milli\second', "translation": r'ms'},
    {"code": r'\milli\coulomb\per\minute', "translation": r'mC/min'},
    {"code": r'\coulomb\per\minute', "translation": r'C/min'},
    {"code": r'\micro\coulomb\per\second', "translation": r'\mu{C/s}'},
    {"code": r'\milli\coulomb\per\second', "translation": r'mC/s'},
    {"code": r'\coulomb\per\second', "translation": r'C/s'},
    {"code": r'\micro\ampere', "translation": r'\mu{A}'},
    {"code": r'\milli\ampere', "translation": r'mA'},
    {"code": r'\electronmass', "translation": r'm_e'},
    {"code": r'\nano\gram', "translation": r'ng'},
    {"code": r'\micro\gram', "translation": r'\mu{g}'},
    {"code": r'\milli\gram', "translation": r'mg'},
    {"code": r'\SIUnitSymbolDegree\R', "translation": r'\degree{R}'},
    {"code": r'\SIUnitSymbolDegree\F', "translation": r'\degree{F}'},
    {"code": r'\SIUnitSymbolDegree', "translation": r'\text{\textdegree}'},
    {"code": r'\radian', "translation": r'rad'},
    {"code": r'\angstrom', "translation": r'\text{\AA}'},
    {"code": r'\pico\meter', "translation": r'pm'},
    {"code": r'\deci\meter', "translation": r'dm'},
    {"code": r'\nano\meter', "translation": r'nm'},
    {"code": r'\micro\meter', "translation": r'\mu{m}'},
    {"code": r'\milli\meter', "translation": r'mm'},
    {"code": r'\milli\ohm', "translation": r'm\Omega'},
    {"code": r'\kilo\ohm', "translation": r'k\Omega'},
    {"code": r'\mega\ohm', "translation": r'M\Omega'},
    {"code": r'\mili\ohm', "translation": r'm\Omega'},
    {"code": r'\micro\ohm', "translation": r'\mu\Omega'},
    {"code": r'\nano\ohm', "translation": r'n\Omega'},
    {"code": r'\pico\ohm', "translation": r'p\Omega'},
    {"code": r'\milli\farad', "translation": r'mF'},
    {"code": r'\micro\farad', "translation": r'\mu{F}'},
    {"code": r'\nano\farad', "translation": r'nF'},
    {"code": r'\pico\farad', "translation": r'pF'},
    {"code": r'\kilo\farad', "translation": r'kF'},
    {"code": r'\henry', "translation": r'H'},
    {"code": r'\milli\henry', "translation": r'mH'},
    {"code": r'\micro\henry', "translation": r'\mu{H}'},
    {"code": r'\nano\henry', "translation": r'nH'},
    {"code": r'\pico\henry', "translation": r'pH'},
    {"code": r'\kilo\henry', "translation": r'kH'},
    {"code": r'\farad', "translation": r'F'},
    {"code": r'\ohm', "translation": r'\Omega'},
    {"code": r'\volt', "translation": r'V'},
    {"code": r'\ampere', "translation": r'A'},
    {"code": r'\weber', "translation": r'Wb'},
    {"code": r'\hertz', "translation": r'Hz'},
    {"code": r'\watt', "translation": r'W'},
    {"code": r'\celsius', "translation": r'\degree{C}'},
    {"code": r'\degreeCelsius', "translation": r'\degree{C}'},
    {
      "code": r'\joule\per\kelvin',
      "translation": r'JK^{-1}',
      "per-mode=symbol": r'J/K'
    },
    {
      "code": r'\milli\meter\cubed',
      "translation": r'mm^{-3}',
      "per-mode=symbol": r'mm^{3}'
    },
    {
      "code": r'\gram\per\centi\meter\cubed',
      "translation": r'gcm^{-3}',
      "per-mode=symbol": r'g/cm^{3}'
    },
    {
      "code": r'\kilogram\metre\per\second',
      "translation": r'kg ms^{-1}',
      "per-mode=symbol": r'kg m/s'
    },
    {
      "code": r'\kilogram\metre\per\ampere\per\second',
      "translation": r'kg ms^{-1}',
      "per-mode=symbol": r'kg m/(As)'
    },
    {
      "code": r'\joule\per\mole\per\kelvin',
      "translation": r'J mol^{-1} K^{-1}',
      "per-mode=symbol": r'J mol/K'
    },
    {"code": r'\kelvin', "translation": r'K', "per-mode=symbol": r'K'},
    {"code": r'\kilogram', "translation": r'kg', "per-mode=symbol": r'kg'},
    {
      "code": r'\meter\per\second',
      "translation": r'ms^{-1}',
      "per-mode=symbol": r'm/s'
    },
    {
      "code": r'\watt\per\meter\squared\kelvin\tothe',
      "translation": r'W m^{-2} K',
      "per-mode=symbol": r'W m^{-2} / K'
    },
    {"code": r'\joule\second', "translation": r'Js', "per-mode=symbol": r'J/s'},
    {
      "code": r'\meter\kelvin',
      "translation": r'm K',
      "per-mode=symbol": r'm/K'
    },
    {"code": r'\meter', "translation": r'm', "per-mode=symbol": r'm'},
    {"code": r'\joule', "translation": r'J', "per-mode=symbol": r'J'},
    {"code": r'\kilo\meter', "translation": r'km', "per-mode=symbol": r'km'},
    {"code": r'\second', "translation": r's', "per-mode=symbol": r's'},
    {
      "code": r'\newton\meter\squared\per\kilogram\squared',
      "translation": r'N m^2 kg^{-2}',
      "per-mode=symbol": r'N m^2/kg^2'
    },
    {
      "code": r'\meter\per\second\squared',
      "translation": r'ms^{-2}',
      "per-mode=symbol": r'm/s^2'
    },
    {
      "code": r'\kilogram\per\meter\cubed',
      "translation": r'kg m^{-3}',
      "per-mode=symbol": r'kg/m^3'
    },
    {"code": r'\meter\cubed', "translation": r'm^3', "per-mode=symbol": r'm^3'},
    {
      "code": r'\per\centi\meter',
      "translation": r'cm^{-1}',
      "per-mode=symbol": r'c/m'
    },
    {"code": r'\centi\meter', "translation": r'cm', "per-mode=symbol": r'cm'},
    {
      "code": r'\newton\per\meter',
      "translation": r'n/m',
      "per-mode=symbol": r'n/m'
    },
    {"code": r'\milli\volt', "translation": r'mV', "per-mode=symbol": r'mV'},
    {
      "code": r'\meter\squared',
      "translation": r'm^2',
      "per-mode=symbol": r'm^2'
    },
    {"code": r'\tesla', "translation": r'T', "per-mode=symbol": r'T'},
    {
      "code": r'\centi\meter\cubed',
      "translation": r'cm^{3}',
      "per-mode=symbol": r'cm^3'
    },
    {
      "code": r'\mili\meter\cubed',
      "translation": r'mm^{3}',
      "per-mode=symbol": r'mm^3'
    },
    {
      "code": r'\deci\meter\cubed',
      "translation": r'dm^{3}',
      "per-mode=symbol": r'dm^3'
    },
    {"code": r'\gram', "translation": r'g', "per-mode=symbol": r'g'},
  ];
  // function
  translationLatex(String input) {
    // RegExp inlineEquationRegex = RegExp(r'\$(.*?)\$');
    RegExp insideBeginEnumerateRegex =
        RegExp(r'\\begin\{enumerate}(.*?)\\end\{enumerate}', dotAll: true);
    RegExp beginEndCommandRegex =
        RegExp(r'\\begin{.*?}\[.*?]|\\begin{.*?}|\\end{.*?}');
    RegExp siunitXRegex = RegExp(
        r'\\SI{.*?}{.*?}|\\SI\[.*?]{.*?}{.*?}|\\SI{.*?}|\\NUM{.*?}',
        caseSensitive: false);
    RegExp beginEnumerate =
        RegExp(r'\\begin{enumerate}\[.*?]|\\begin{enumerate}|\\end{enumerate}');

    // Iterable<Match> inlineEquation = inlineEquationRegex.allMatches(input);
    Iterable<Match> siunitX = siunitXRegex.allMatches(input);
    Iterable<Match> beginEndCommand = beginEndCommandRegex.allMatches(input);
    Iterable<Match> insideBeginEnumerate =
        insideBeginEnumerateRegex.allMatches(input);
    String result = input;
    // result = result.replaceAll("\\begin{align*}", r"$$");
    // result = result.replaceAll("\\end{align*}", r"$$");
    result = result.replaceAll("{}&", r"&");

    //inline equation
    result = convertDollarInlineLatex(result);
    //beginendcommand
    for (Match match in beginEndCommand) {
      String convertResult = "";
      var item = match.group(0);
      // print(match.group(0));
      RegExp paramRegex = RegExp(r'\{.*?}');
      // RegExp settingRegex = RegExp(r'\[.*?]');
      Iterable<Match> param = paramRegex.allMatches(item!);
      // Iterable<Match> setting = settingRegex.allMatches(item);
      for (Match paramMatch in param) {
        var paramItem = paramMatch.group(0);
        if (paramItem == "{enumerate}") {
          convertResult = item.replaceAll(beginEnumerate, r'\(\newline\)');
        } else if (paramItem == "{align*}" || paramItem == "{equation}") {
          RegExp beginAlignEquation = RegExp(
              r'\\begin{align\*}\[.*?]|\\begin{align\*}|\\begin{equation}\[.*?]|\\begin{equation}');
          RegExp endAlignEquation = RegExp(r'\\end{align\*}|\\end{equation}');
          convertResult = item.replaceAll(beginAlignEquation,
              String.fromCharCode(32) + "@#\\begin{aligned}");
          convertResult = convertResult.replaceAll(
              endAlignEquation, "\\end{aligned}@#" + String.fromCharCode(32));
        } else if (paramItem == "{align}") {
          RegExp beginAlignEquation =
              RegExp(r'\\begin{align}\[.*?]|\\begin{align}');
          RegExp endAlignEquation = RegExp(r'\\end{align}');
          convertResult = item.replaceAll(
              beginAlignEquation, String.fromCharCode(32) + "@#\\begin{align}");
          convertResult = convertResult.replaceAll(
              endAlignEquation, "\\end{align}@#" + String.fromCharCode(32));
        } else if (paramItem == "{aligned}") {
          RegExp beginAlignEquation =
              RegExp(r'\\begin{aligned}\[.*?]|\\begin{aligned}');
          RegExp endAlignEquation = RegExp(r'\\end{aligned}');
          convertResult = item.replaceAll(beginAlignEquation,
              String.fromCharCode(32) + "@#\\begin{equation}\\begin{split}");
          convertResult = convertResult.replaceAll(endAlignEquation,
              "\\end{split}\\end{equation}@#" + String.fromCharCode(32));
        } else if (paramItem == "{center}") {
          RegExp beginAlignEquation =
              RegExp(r'\\begin{center}\[.*?]|\\begin{center}');
          RegExp endAlignEquation = RegExp(r'\\end{center}');
          convertResult = item.replaceAll(beginAlignEquation,
              String.fromCharCode(32) + "@#\\begin{aligned}");
          convertResult = convertResult.replaceAll(
              endAlignEquation, "\\end{aligned}@#" + String.fromCharCode(32));
        } else {
          convertResult = item;
        }
      }
      result = result.replaceAll(item, convertResult);
    }

    //begininside
    for (Match match in insideBeginEnumerate) {
      var item = match.group(0);
      RegExp itemTotalRegex = RegExp(r'(?=\\item).*');
      Iterable<Match> itemTotal = itemTotalRegex.allMatches(item!);

      var convertItem = item.replaceAll(beginEnumerate, r'\(\newline\)');

      int index = 1;
      for (Match itemTotalMatch in itemTotal) {
        String? itemTotalItem = itemTotalMatch.group(0);

        var itemTotalItemReplace = itemTotalItem!.replaceAll(r'\item ', r'');

        convertItem = convertItem.replaceAll(
            itemTotalItem,
            r'(' +
                (index++).toString() +
                r') ' +
                itemTotalItemReplace +
                r'\(\newline\)');
      }
      index = 1;
      var itemNoBeginEnd = item.replaceAll(beginEnumerate, r'\(\newline\)');

      itemNoBeginEnd = convertDollarInlineLatex(itemNoBeginEnd);
      result = result.replaceAll(itemNoBeginEnd, convertItem);
      result = convertDollarInlineLatex(result);
    }
    //siunitx
    for (Match match in siunitX) {
      String convertResult = "";
      String itemProseced;
      String paramItemProseced;
      String par;
      String? mode;
      // String tothe;
      String? itemsiunitX = match.group(0);
      RegExp totheRexexp = RegExp(r'tothe');
      if (totheRexexp.hasMatch(itemsiunitX!)) {
        itemProseced = itemsiunitX + "}";
      } else {
        itemProseced = itemsiunitX;
      }

      RegExp modeRexexp = RegExp(r'\[.*?]');
      RegExp paramRexexp = RegExp(r'{.*?}');
      Iterable<Match> modeMatch = modeRexexp.allMatches(itemsiunitX);
      for (Match match in modeMatch) {
        mode = match.group(0)!;
      }
      Iterable<Match> param = paramRexexp.allMatches(itemsiunitX);

      if (modeMatch.length != 0) {
        for (Match match in param) {
          String? itemParam = match.group(0);
          if (totheRexexp.hasMatch(itemParam!)) {
            paramItemProseced = itemParam + "}";
          } else {
            paramItemProseced = itemParam;
          }
          par = replaceAllCurlyBraces(paramItemProseced);
          convertResult += replaceSiunitx(mode!, par) + r'''\,''';
        }
      } else {
        for (Match match in param) {
          String? itemParam = match.group(0);
          if (totheRexexp.hasMatch(itemParam!)) {
            RegExp findTotheRegexp = RegExp(r'\[.*?]');
            paramItemProseced = itemParam + "}";
            // Iterable<Match> findTothe = findTotheRegexp.allMatches(itemsiunitX);
            // for (Match match in findTothe) {
            //   tothe = "^{" + replaceAllCurlyBraces(match.group(1)) + "}";
            // }
            paramItemProseced =
                paramItemProseced.replaceAll(findTotheRegexp, "");
          } else {
            paramItemProseced = itemParam;
          }
          par = replaceAllCurlyBraces(paramItemProseced);
          convertResult += replaceSiunitx("", par) + r'''\,''';
        }
      }

      result = result.replaceAll(itemProseced, r'$' + convertResult + r'$');
    }
    RegExp findDollarIsnsideAlignRegex = RegExp(r'\@\#(.*?)\@\#', dotAll: true);
    Iterable<Match> findDollarIsnsideAlign =
        findDollarIsnsideAlignRegex.allMatches(result);
    for (Match match in findDollarIsnsideAlign) {
      String? sebelum = match.group(0);
      String hasil = sebelum!.replaceAll(r'$', r'');
      result = result.replaceAll(sebelum, hasil);
    }
    result = convertDollarInlineLatex(result);
    result = result.replaceAll("@#", r"$$");
    result = result.replaceAll(r"\\", r"\quad\quad\\");
    result = result.replaceAll(r"\end{align}", r"\quad\quad\end{align}");
    result = result.replaceAll(r"\end{split}", r"\quad\quad\end{split}");
    // print("result#######");
    // print(result);
    // print("result#######");
    // result = result.replaceAll(String.fromCharCode(10), r"$$\\~\\\quad\quad$$");
    return result;
  }

  convertDollarInlineLatex(input) {
    String hasilConvert;
    String result = input;
    RegExp inlineEquationRegex = RegExp(r'\$(.*?)\$');
    Iterable<Match> inlineEquation = inlineEquationRegex.allMatches(result);
    for (Match match in inlineEquation) {
      String? sblmConvert = match.group(0);
      RegExp siunitXRegex =
          RegExp(r'\\SI{.*?}{.*?}|\\SI\[.*?]{.*?}{.*?}|\\SI{.*?}|\\NUM{.*?}');

      if (siunitXRegex.hasMatch(sblmConvert!)) {
        hasilConvert = match.group(1)!;
      } else {
        hasilConvert = r'\(' + match.group(1).toString() + r'\)';
      }
      result = result.replaceAll(sblmConvert, hasilConvert);
    }
    // print("result");
    // print(result);
    return result;
  }

  replaceSiunitx(String mode, String str) {
    String result = str;
    bool codeMatch = false;
    String? nominal;
    String? pangkat;

    for (var item in siunitX1) {
      if (str == item["code"] && mode == "" && codeMatch == false) {
        result = item["translation"];
        codeMatch = true;
      } else if (str == item["code"] &&
          mode == "[per-mode=symbol]" &&
          codeMatch == false) {
        result = item["per-mode=symbol"];
        codeMatch = true;
      } else if (str != item["code"] && codeMatch == false) {
        RegExp exponenSiunitXcond1 = RegExp(r'-?\d+(?=e).-?\d+');
        RegExp exponenSiunitXcond2 = RegExp(r'(?=e).-?\d+');
        var a1 = exponenSiunitXcond1.hasMatch(str);
        var b1 = exponenSiunitXcond2.hasMatch(str);

        if (a1 || b1) {
          RegExp pangkatRegexCond = RegExp(r'(?<=e).?\d+');
          Iterable<Match> pangkatRegex = pangkatRegexCond.allMatches(str);

          for (Match match in pangkatRegex) {
            pangkat = match.group(0)!;
          }

          RegExp nominalRegexCond = RegExp(r'-?\d+(?=e)');
          Iterable<Match> nominalRegex = nominalRegexCond.allMatches(str);
          for (Match match in nominalRegex) {
            nominal = match.group(0)!;
          }

          if (pangkat != null && nominal != null) {
            result = nominal + " x 10^{" + pangkat + "}";
          } else if (pangkat != null && nominal == null) {
            result = "10^" + pangkat;
          } else {
            result = str;
          }
        } else {
          result = str;
        }
      }
    }

    return result;
  }

  replaceAllCurlyBraces(String sentences) {
    String temp = sentences.replaceAll("{", "").replaceAll("}", "");

    return temp;
  }

  // showImg(String id, int index) {
  //   return globals.fetchAPI.getImg(id).then((_linkImg) {
  //     return _linkImg[index]["deskripsi"];
  //   });
  // }

  translationLatexPreiview(
      String input,
      List _listSoal,
      int _no,
      List _linkImg,
      BuildContext context,
      var updateRenderProgress,
      var getLineCntLength,
      String _option,
      String _mode,
      String _jawabanBenar,
      List _listJawaban,
      int _nomor,
      var _skeletonLoading) {
    // print("input#######");
    // print(input);
    // print("input#######");
    RegExp imgRegex = RegExp(r'\img\d+');
    RegExp numberImagesRegex = RegExp(r'(?<=img)\d+');

    String text = "";
    List<Widget> def = [];
    var a = input.split(" ").toList();

    var abc = a.map((e) {
      return e;
    }).toList();

    if (imgRegex.hasMatch(input)) {
      // print("dengan gambar");
      for (var item in abc) {
        if (imgRegex.hasMatch(item)) {
          Iterable<Match> numberImages = numberImagesRegex.allMatches(item);

          def.add(TeXView(child: TeXViewDocument(text)));
          for (Match match in numberImages) {
            int index = int.parse(match.group(0).toString());
            def.add(_linkImg.length == 0
                ? CircularProgressIndicator()
                : CachedNetworkImage(
                    imageUrl: _baseUrl + _linkImg[index]["deskripsi"],
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ));
          }

          text = "";
        } else {
          text += item + " ";
        }
      }
      // print("defasdasdads");
      // print(text);
      def.add(TeXView(
          // loadingWidgetBuilder: (BuildContext context) => _skeletonLoading,
          // onRenderFinished: (res) {
          //   updateRenderProgress(1);
          // },
          style: TeXViewStyle(
              backgroundColor: _mode == "Pembahasan"
                  ? _option == _jawabanBenar.toUpperCase()
                      ? Color(0xffFFF9C2)
                      : Colors.white
                  : _listJawaban[_nomor - 1] == _option
                      ? Color(0xffFFF9C2)
                      : Colors.white,
              padding: TeXViewPadding.all(0),
              fontStyle: TeXViewFontStyle(fontFamily: 'Nunito'),
              textAlign: TeXViewTextAlign.Justify),
          child: TeXViewDocument(text)));
      getLineCntLength(def.length);

      // print("defasdasdads");
      // print(def);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: def.toList(),
      );
    } else {
      // print("tanpa gambar");
      return TeXView(
          // loadingWidgetBuilder: (BuildContext context) => _skeletonLoading,
          // onRenderFinished: (res) {
          //   updateRenderProgress(1);
          // },
          style: TeXViewStyle(
              backgroundColor: _mode == "Pembahasan"
                  ? _option == _jawabanBenar.toUpperCase()
                      ? Color(0xffFFF9C2)
                      : Colors.white
                  : _listJawaban[_nomor - 1] == _option
                      ? Color(0xffFFF9C2)
                      : Colors.white,
              padding: TeXViewPadding.all(0),
              fontStyle: TeXViewFontStyle(fontFamily: 'Nunito'),
              textAlign: TeXViewTextAlign.Justify),
          child: TeXViewDocument(input));
    }

    // }
  }
}
