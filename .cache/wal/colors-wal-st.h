const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#000000", /* black   */
  [1] = "#A05969", /* red     */
  [2] = "#C16B7E", /* green   */
  [3] = "#BD7A80", /* yellow  */
  [4] = "#CE7688", /* blue    */
  [5] = "#BE8F86", /* magenta */
  [6] = "#CC8F8D", /* cyan    */
  [7] = "#e8bac2", /* white   */

  /* 8 bright colors */
  [8]  = "#a28287",  /* black   */
  [9]  = "#A05969",  /* red     */
  [10] = "#C16B7E", /* green   */
  [11] = "#BD7A80", /* yellow  */
  [12] = "#CE7688", /* blue    */
  [13] = "#BE8F86", /* magenta */
  [14] = "#CC8F8D", /* cyan    */
  [15] = "#e8bac2", /* white   */

  /* special colors */
  [256] = "#000000", /* background */
  [257] = "#e8bac2", /* foreground */
  [258] = "#e8bac2",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
