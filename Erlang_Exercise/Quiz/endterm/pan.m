#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC :init: */
	case 3: // STATE 1 - fmep_mc.pml:56 - [i = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		(trpt+1)->bup.oval = ((int)((P2 *)_this)->i);
		((P2 *)_this)->i = 0;
#ifdef VAR_RANGES
		logval(":init::i", ((int)((P2 *)_this)->i));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - fmep_mc.pml:56 - [((i<=1))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][2] = 1;
		if (!((((int)((P2 *)_this)->i)<=1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - fmep_mc.pml:57 - [flag[i] = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[2][3] = 1;
		(trpt+1)->bup.oval = ((int)now.flag[ Index(((int)((P2 *)_this)->i), 2) ]);
		now.flag[ Index(((P2 *)_this)->i, 2) ] = 0;
#ifdef VAR_RANGES
		logval("flag[:init::i]", ((int)now.flag[ Index(((int)((P2 *)_this)->i), 2) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 4 - fmep_mc.pml:56 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[2][4] = 1;
		(trpt+1)->bup.oval = ((int)((P2 *)_this)->i);
		((P2 *)_this)->i = (((int)((P2 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval(":init::i", ((int)((P2 *)_this)->i));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 10 - fmep_mc.pml:61 - [(run P(0))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][10] = 1;
		if (!(addproc(II, 1, 0, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 11 - fmep_mc.pml:62 - [(run Q(1))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][11] = 1;
		if (!(addproc(II, 1, 1, 1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 9: // STATE 13 - fmep_mc.pml:64 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[2][13] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Q */
	case 10: // STATE 1 - fmep_mc.pml:33 - [flag[me] = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[1][1] = 1;
		(trpt+1)->bup.oval = ((int)now.flag[ Index(((int)((P1 *)_this)->me), 2) ]);
		now.flag[ Index(((P1 *)_this)->me, 2) ] = 1;
#ifdef VAR_RANGES
		logval("flag[Q:me]", ((int)now.flag[ Index(((int)((P1 *)_this)->me), 2) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 2 - fmep_mc.pml:35 - [((turn==me))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		if (!((((int)now.turn)==((int)((P1 *)_this)->me))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 12: // STATE 5 - fmep_mc.pml:38 - [((flag[(1-me)]==0))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][5] = 1;
		if (!((((int)now.flag[ Index((1-((int)((P1 *)_this)->me)), 2) ])==0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 11 - fmep_mc.pml:41 - [turn = me] (0:0:1 - 3)
		IfNotBlocked
		reached[1][11] = 1;
		(trpt+1)->bup.oval = ((int)now.turn);
		now.turn = ((int)((P1 *)_this)->me);
#ifdef VAR_RANGES
		logval("turn", ((int)now.turn));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 15 - fmep_mc.pml:44 - [printf('%d went in\\n',me)] (0:0:0 - 3)
		IfNotBlocked
		reached[1][15] = 1;
		Printf("%d went in\n", ((int)((P1 *)_this)->me));
		_m = 3; goto P999; /* 0 */
	case 15: // STATE 16 - fmep_mc.pml:46 - [c = (c+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][16] = 1;
		(trpt+1)->bup.oval = ((int)now.c);
		now.c = (((int)now.c)+1);
#ifdef VAR_RANGES
		logval("c", ((int)now.c));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 16: // STATE 17 - fmep_mc.pml:47 - [assert((c==1))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][17] = 1;
		spin_assert((((int)now.c)==1), "(c==1)", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 17: // STATE 18 - fmep_mc.pml:48 - [c = (c-1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][18] = 1;
		(trpt+1)->bup.oval = ((int)now.c);
		now.c = (((int)now.c)-1);
#ifdef VAR_RANGES
		logval("c", ((int)now.c));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 18: // STATE 19 - fmep_mc.pml:49 - [flag[me] = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[1][19] = 1;
		(trpt+1)->bup.oval = ((int)now.flag[ Index(((int)((P1 *)_this)->me), 2) ]);
		now.flag[ Index(((P1 *)_this)->me, 2) ] = 0;
#ifdef VAR_RANGES
		logval("flag[Q:me]", ((int)now.flag[ Index(((int)((P1 *)_this)->me), 2) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 19: // STATE 20 - fmep_mc.pml:50 - [printf('%d went out\\n',me)] (0:0:0 - 1)
		IfNotBlocked
		reached[1][20] = 1;
		Printf("%d went out\n", ((int)((P1 *)_this)->me));
		_m = 3; goto P999; /* 0 */
	case 20: // STATE 24 - fmep_mc.pml:52 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][24] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC P */
	case 21: // STATE 1 - fmep_mc.pml:10 - [flag[me] = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		(trpt+1)->bup.oval = ((int)now.flag[ Index(((int)((P0 *)_this)->me), 2) ]);
		now.flag[ Index(((P0 *)_this)->me, 2) ] = 1;
#ifdef VAR_RANGES
		logval("flag[P:me]", ((int)now.flag[ Index(((int)((P0 *)_this)->me), 2) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 22: // STATE 2 - fmep_mc.pml:12 - [((turn==me))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		if (!((((int)now.turn)==((int)((P0 *)_this)->me))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 23: // STATE 5 - fmep_mc.pml:15 - [((flag[(1-me)]==0))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][5] = 1;
		if (!((((int)now.flag[ Index((1-((int)((P0 *)_this)->me)), 2) ])==0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 24: // STATE 11 - fmep_mc.pml:18 - [turn = me] (0:0:1 - 3)
		IfNotBlocked
		reached[0][11] = 1;
		(trpt+1)->bup.oval = ((int)now.turn);
		now.turn = ((int)((P0 *)_this)->me);
#ifdef VAR_RANGES
		logval("turn", ((int)now.turn));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 25: // STATE 15 - fmep_mc.pml:21 - [printf('%d went in\\n',me)] (0:0:0 - 3)
		IfNotBlocked
		reached[0][15] = 1;
		Printf("%d went in\n", ((int)((P0 *)_this)->me));
		_m = 3; goto P999; /* 0 */
	case 26: // STATE 16 - fmep_mc.pml:23 - [c = (c+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][16] = 1;
		(trpt+1)->bup.oval = ((int)now.c);
		now.c = (((int)now.c)+1);
#ifdef VAR_RANGES
		logval("c", ((int)now.c));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 27: // STATE 17 - fmep_mc.pml:24 - [assert((c==1))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][17] = 1;
		spin_assert((((int)now.c)==1), "(c==1)", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 28: // STATE 18 - fmep_mc.pml:25 - [c = (c-1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][18] = 1;
		(trpt+1)->bup.oval = ((int)now.c);
		now.c = (((int)now.c)-1);
#ifdef VAR_RANGES
		logval("c", ((int)now.c));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 29: // STATE 19 - fmep_mc.pml:26 - [flag[me] = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][19] = 1;
		(trpt+1)->bup.oval = ((int)now.flag[ Index(((int)((P0 *)_this)->me), 2) ]);
		now.flag[ Index(((P0 *)_this)->me, 2) ] = 0;
#ifdef VAR_RANGES
		logval("flag[P:me]", ((int)now.flag[ Index(((int)((P0 *)_this)->me), 2) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 30: // STATE 20 - fmep_mc.pml:27 - [printf('%d went out\\n',me)] (0:0:0 - 1)
		IfNotBlocked
		reached[0][20] = 1;
		Printf("%d went out\n", ((int)((P0 *)_this)->me));
		_m = 3; goto P999; /* 0 */
	case 31: // STATE 24 - fmep_mc.pml:29 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][24] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

