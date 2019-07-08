// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  hsG_0__0 (struct dummyq_struct * I1249, EBLK  * I1243, U  I673);
void  hsG_0__0 (struct dummyq_struct * I1249, EBLK  * I1243, U  I673)
{
    U  I1501;
    U  I1502;
    U  I1503;
    struct futq * I1504;
    struct dummyq_struct * pQ = I1249;
    I1501 = ((U )vcs_clocks) + I673;
    I1503 = I1501 & ((1 << fHashTableSize) - 1);
    I1243->I713 = (EBLK  *)(-1);
    I1243->I717 = I1501;
    if (I1501 < (U )vcs_clocks) {
        I1502 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1243, I1502 + 1, I1501);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I673 == 1)) {
        I1243->I719 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I713 = I1243;
        peblkFutQ1Tail = I1243;
    }
    else if ((I1504 = pQ->I1148[I1503].I731)) {
        I1243->I719 = (struct eblk *)I1504->I730;
        I1504->I730->I713 = (RP )I1243;
        I1504->I730 = (RmaEblk  *)I1243;
    }
    else {
        sched_hsopt(pQ, I1243, I1501);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
