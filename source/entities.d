dchar[string] entity_name_lookup;
static this()
{
    entity_name_lookup = [
        "quot": '\&quot;', "amp": '\&amp;', "lt": '\&lt;', "gt": '\&gt;',
        "OElig": '\&OElig;', "oelig": '\&oelig;', "Scaron": '\&Scaron;',
        "scaron": '\&scaron;', "Yuml": '\&Yuml;', "circ": '\&circ;',
        "tilde": '\&tilde;', "ensp": '\&ensp;', "emsp": '\&emsp;',
        "thinsp": '\&thinsp;', "zwnj": '\&zwnj;', "zwj": '\&zwj;',
        "lrm": '\&lrm;', "rlm": '\&rlm;', "ndash": '\&ndash;', "mdash": '\&mdash;',
        "lsquo": '\&lsquo;', "rsquo": '\&rsquo;', "sbquo": '\&sbquo;',
        "ldquo": '\&ldquo;', "rdquo": '\&rdquo;', "bdquo": '\&bdquo;',
        "dagger": '\&dagger;', "Dagger": '\&Dagger;', "permil": '\&permil;',
        "lsaquo": '\&lsaquo;', "rsaquo": '\&rsaquo;', "euro": '\&euro;',
        "nbsp": '\&nbsp;', "iexcl": '\&iexcl;', "cent": '\&cent;',
        "pound": '\&pound;', "curren": '\&curren;', "yen": '\&yen;',
        "brvbar": '\&brvbar;', "sect": '\&sect;', "uml": '\&uml;',
        "copy": '\&copy;', "ordf": '\&ordf;', "laquo": '\&laquo;', "not": '\&not;',
        "shy": '\&shy;', "reg": '\&reg;', "macr": '\&macr;', "deg": '\&deg;',
        "plusmn": '\&plusmn;', "sup2": '\&sup2;', "sup3": '\&sup3;',
        "acute": '\&acute;', "micro": '\&micro;', "para": '\&para;',
        "middot": '\&middot;', "cedil": '\&cedil;', "sup1": '\&sup1;',
        "ordm": '\&ordm;', "raquo": '\&raquo;', "frac14": '\&frac14;',
        "frac12": '\&frac12;', "frac34": '\&frac34;', "iquest": '\&iquest;',
        "Agrave": '\&Agrave;', "Aacute": '\&Aacute;', "Acirc": '\&Acirc;',
        "Atilde": '\&Atilde;', "Auml": '\&Auml;', "Aring": '\&Aring;',
        "AElig": '\&AElig;', "Ccedil": '\&Ccedil;', "Egrave": '\&Egrave;',
        "Eacute": '\&Eacute;', "Ecirc": '\&Ecirc;', "Euml": '\&Euml;',
        "Igrave": '\&Igrave;', "Iacute": '\&Iacute;', "Icirc": '\&Icirc;',
        "Iuml": '\&Iuml;', "ETH": '\&ETH;', "Ntilde": '\&Ntilde;',
        "Ograve": '\&Ograve;', "Oacute": '\&Oacute;', "Ocirc": '\&Ocirc;',
        "Otilde": '\&Otilde;', "Ouml": '\&Ouml;', "times": '\&times;',
        "Oslash": '\&Oslash;', "Ugrave": '\&Ugrave;', "Uacute": '\&Uacute;',
        "Ucirc": '\&Ucirc;', "Uuml": '\&Uuml;', "Yacute": '\&Yacute;',
        "THORN": '\&THORN;', "szlig": '\&szlig;', "agrave": '\&agrave;',
        "aacute": '\&aacute;', "acirc": '\&acirc;', "atilde": '\&atilde;',
        "auml": '\&auml;', "aring": '\&aring;', "aelig": '\&aelig;',
        "ccedil": '\&ccedil;', "egrave": '\&egrave;', "eacute": '\&eacute;',
        "ecirc": '\&ecirc;', "euml": '\&euml;', "igrave": '\&igrave;',
        "iacute": '\&iacute;', "icirc": '\&icirc;', "iuml": '\&iuml;',
        "eth": '\&eth;', "ntilde": '\&ntilde;', "ograve": '\&ograve;',
        "oacute": '\&oacute;', "ocirc": '\&ocirc;', "otilde": '\&otilde;',
        "ouml": '\&ouml;', "divide": '\&divide;', "oslash": '\&oslash;',
        "ugrave": '\&ugrave;', "uacute": '\&uacute;', "ucirc": '\&ucirc;',
        "uuml": '\&uuml;', "yacute": '\&yacute;', "thorn": '\&thorn;',
        "yuml": '\&yuml;', "fnof": '\&fnof;', "Alpha": '\&Alpha;',
        "Beta": '\&Beta;', "Gamma": '\&Gamma;', "Delta": '\&Delta;',
        "Epsilon": '\&Epsilon;', "Zeta": '\&Zeta;', "Eta": '\&Eta;',
        "Theta": '\&Theta;', "Iota": '\&Iota;', "Kappa": '\&Kappa;',
        "Lambda": '\&Lambda;', "Mu": '\&Mu;', "Nu": '\&Nu;', "Xi": '\&Xi;',
        "Omicron": '\&Omicron;', "Pi": '\&Pi;', "Rho": '\&Rho;',
        "Sigma": '\&Sigma;', "Tau": '\&Tau;', "Upsilon": '\&Upsilon;',
        "Phi": '\&Phi;', "Chi": '\&Chi;', "Psi": '\&Psi;', "Omega": '\&Omega;',
        "alpha": '\&alpha;', "beta": '\&beta;', "gamma": '\&gamma;',
        "delta": '\&delta;', "epsilon": '\&epsilon;', "zeta": '\&zeta;',
        "eta": '\&eta;', "theta": '\&theta;', "iota": '\&iota;',
        "kappa": '\&kappa;', "lambda": '\&lambda;', "mu": '\&mu;', "nu": '\&nu;',
        "xi": '\&xi;', "omicron": '\&omicron;', "pi": '\&pi;', "rho": '\&rho;',
        "sigmaf": '\&sigmaf;', "sigma": '\&sigma;', "tau": '\&tau;',
        "upsilon": '\&upsilon;', "phi": '\&phi;', "chi": '\&chi;', "psi": '\&psi;',
        "omega": '\&omega;', "thetasym": '\&thetasym;', "upsih": '\&upsih;',
        "piv": '\&piv;', "bull": '\&bull;', "hellip": '\&hellip;',
        "prime": '\&prime;', "Prime": '\&Prime;', "oline": '\&oline;',
        "frasl": '\&frasl;', "weierp": '\&weierp;', "image": '\&image;',
        "real": '\&real;', "trade": '\&trade;', "alefsym": '\&alefsym;',
        "larr": '\&larr;', "uarr": '\&uarr;', "rarr": '\&rarr;', "darr": '\&darr;',
        "harr": '\&harr;', "crarr": '\&crarr;', "lArr": '\&lArr;',
        "uArr": '\&uArr;', "rArr": '\&rArr;', "dArr": '\&dArr;', "hArr": '\&hArr;',
        "forall": '\&forall;', "part": '\&part;', "exist": '\&exist;',
        "empty": '\&empty;', "nabla": '\&nabla;', "isin": '\&isin;',
        "notin": '\&notin;', "ni": '\&ni;', "prod": '\&prod;', "sum": '\&sum;',
        "minus": '\&minus;', "lowast": '\&lowast;', "radic": '\&radic;',
        "prop": '\&prop;', "infin": '\&infin;', "ang": '\&ang;', "and": '\&and;',
        "or": '\&or;', "cap": '\&cap;', "cup": '\&cup;', "int": '\&int;',
        "there4": '\&there4;', "sim": '\&sim;', "cong": '\&cong;',
        "asymp": '\&asymp;', "ne": '\&ne;', "equiv": '\&equiv;', "le": '\&le;',
        "ge": '\&ge;', "sub": '\&sub;', "sup": '\&sup;', "nsub": '\&nsub;',
        "sube": '\&sube;', "supe": '\&supe;', "oplus": '\&oplus;',
        "otimes": '\&otimes;', "perp": '\&perp;', "sdot": '\&sdot;',
        "lceil": '\&lceil;', "rceil": '\&rceil;', "lfloor": '\&lfloor;',
        "rfloor": '\&rfloor;', "loz": '\&loz;', "spades": '\&spades;',
        "clubs": '\&clubs;', "hearts": '\&hearts;', "diams": '\&diams;',
        "lang": '\&lang;', "rang": '\&rang;' ];

    entity_name_lookup.rehash();
}


import std.regex;
dchar entity_found(Captures!string m)
{
    import std.conv, std.range;

    auto entity = m.hit[1..$-1];

    // Convert named entities
    if (auto echar = entity in entity_name_lookup)
        return *echar;

    // Convert hex entities
    if (entity.front == 'x')
    {
        try return cast(dchar)entity[1..$].to!uint(16);
        catch (ConvException) { }
    }

    // Convert decimal entities
    try return cast(dchar)entity.to!uint;
    catch (ConvException) { }

    // give up (I could keep the original but let's just drop it entirely)
    return ' ';
}

string entities_to_uni(string input)
{
    static auto entity_re = ctRegex!(r"&\S+;");
    return replaceAll!entity_found(input, entity_re);
}
