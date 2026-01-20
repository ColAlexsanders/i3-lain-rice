static const char norm_fg[] = "#e8bac2";
static const char norm_bg[] = "#000000";
static const char norm_border[] = "#a28287";

static const char sel_fg[] = "#e8bac2";
static const char sel_bg[] = "#C16B7E";
static const char sel_border[] = "#e8bac2";

static const char urg_fg[] = "#e8bac2";
static const char urg_bg[] = "#A05969";
static const char urg_border[] = "#A05969";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
