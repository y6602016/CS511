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

		 /* PROC Q */
	case 3: // STATE 1 - attempt4.pml:22 - [wantQ = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[1][1] = 1;
		(trpt+1)->bup.oval = ((int)now.wantQ);
		now.wantQ = 1;
#ifdef VAR_RANGES
		logval("wantQ", ((int)now.wantQ));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - attempt4.pml:24 - [(wantP)] (0:0:0 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		if (!(((int)now.wantP)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - attempt4.pml:24 - [wantQ = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[1][3] = 1;
		(trpt+1)->bup.oval = ((int)now.wantQ);
		now.wantQ = 0;
#ifdef VAR_RANGES
		logval("wantQ", ((int)now.wantQ));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 4 - attempt4.pml:24 - [wantQ = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[1][4] = 1;
		(trpt+1)->bup.oval = ((int)now.wantQ);
		now.wantQ = 1;
#ifdef VAR_RANGES
		logval("wantQ", ((int)now.wantQ));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 10 - attempt4.pml:31 - [wantQ = 0] (0:0:1 - 3)
		IfNotBlocked
		reached[1][10] = 1;
		(trpt+1)->bup.oval = ((int)now.wantQ);
		now.wantQ = 0;
#ifdef VAR_RANGES
		logval("wantQ", ((int)now.wantQ));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 14 - attempt4.pml:33 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][14] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC P */
	case 9: // STATE 1 - attempt4.pml:7 - [wantP = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		(trpt+1)->bup.oval = ((int)now.wantP);
		now.wantP = 1;
#ifdef VAR_RANGES
		logval("wantP", ((int)now.wantP));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 2 - attempt4.pml:9 - [(wantQ)] (0:0:0 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		if (!(((int)now.wantQ)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 3 - attempt4.pml:9 - [wantP = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][3] = 1;
		(trpt+1)->bup.oval = ((int)now.wantP);
		now.wantP = 0;
#ifdef VAR_RANGES
		logval("wantP", ((int)now.wantP));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 12: // STATE 4 - attempt4.pml:9 - [wantP = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[0][4] = 1;
		(trpt+1)->bup.oval = ((int)now.wantP);
		now.wantP = 1;
#ifdef VAR_RANGES
		logval("wantP", ((int)now.wantP));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 10 - attempt4.pml:16 - [wantP = 0] (0:0:1 - 3)
		IfNotBlocked
		reached[0][10] = 1;
		(trpt+1)->bup.oval = ((int)now.wantP);
		now.wantP = 0;
#ifdef VAR_RANGES
		logval("wantP", ((int)now.wantP));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 14 - attempt4.pml:18 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][14] = 1;
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

