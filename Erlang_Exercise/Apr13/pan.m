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

		 /* PROC Feline */
	case 3: // STATE 1 - zoo.pml:12 - [((mutexFelines>0))] (5:0:1 - 1)
		IfNotBlocked
		reached[1][1] = 1;
		if (!((((int)now.mutexFelines)>0)))
			continue;
		/* merge: mutexFelines = (mutexFelines-1)(0, 2, 5) */
		reached[1][2] = 1;
		(trpt+1)->bup.oval = ((int)now.mutexFelines);
		now.mutexFelines = (((int)now.mutexFelines)-1);
#ifdef VAR_RANGES
		logval("mutexFelines", ((int)now.mutexFelines));
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 4: // STATE 5 - zoo.pml:49 - [felines = (felines+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][5] = 1;
		(trpt+1)->bup.oval = ((int)now.felines);
		now.felines = (((int)now.felines)+1);
#ifdef VAR_RANGES
		logval("felines", ((int)now.felines));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 6 - zoo.pml:51 - [((felines==1))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][6] = 1;
		if (!((((int)now.felines)==1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 7 - zoo.pml:12 - [((area>0))] (16:0:1 - 1)
		IfNotBlocked
		reached[1][7] = 1;
		if (!((((int)now.area)>0)))
			continue;
		/* merge: area = (area-1)(0, 8, 16) */
		reached[1][8] = 1;
		(trpt+1)->bup.oval = ((int)now.area);
		now.area = (((int)now.area)-1);
#ifdef VAR_RANGES
		logval("area", ((int)now.area));
#endif
		;
		/* merge: .(goto)(0, 14, 16) */
		reached[1][14] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 7: // STATE 15 - zoo.pml:17 - [mutexFelines = (mutexFelines+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][15] = 1;
		(trpt+1)->bup.oval = ((int)now.mutexFelines);
		now.mutexFelines = (((int)now.mutexFelines)+1);
#ifdef VAR_RANGES
		logval("mutexFelines", ((int)now.mutexFelines));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 17 - zoo.pml:12 - [((feedinglot>0))] (21:0:1 - 1)
		IfNotBlocked
		reached[1][17] = 1;
		if (!((((int)now.feedinglot)>0)))
			continue;
		/* merge: feedinglot = (feedinglot-1)(0, 18, 21) */
		reached[1][18] = 1;
		(trpt+1)->bup.oval = ((int)now.feedinglot);
		now.feedinglot = (((int)now.feedinglot)-1);
#ifdef VAR_RANGES
		logval("feedinglot", ((int)now.feedinglot));
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 9: // STATE 21 - zoo.pml:58 - [c = (c+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][21] = 1;
		(trpt+1)->bup.oval = ((int)now.c);
		now.c = (((int)now.c)+1);
#ifdef VAR_RANGES
		logval("c", ((int)now.c));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 22 - zoo.pml:59 - [assert((c<3))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][22] = 1;
		spin_assert((((int)now.c)<3), "(c<3)", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 23 - zoo.pml:60 - [c = (c-1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][23] = 1;
		(trpt+1)->bup.oval = ((int)now.c);
		now.c = (((int)now.c)-1);
#ifdef VAR_RANGES
		logval("c", ((int)now.c));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 12: // STATE 24 - zoo.pml:17 - [feedinglot = (feedinglot+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][24] = 1;
		(trpt+1)->bup.oval = ((int)now.feedinglot);
		now.feedinglot = (((int)now.feedinglot)+1);
#ifdef VAR_RANGES
		logval("feedinglot", ((int)now.feedinglot));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 26 - zoo.pml:12 - [((mutexFelines>0))] (30:0:1 - 1)
		IfNotBlocked
		reached[1][26] = 1;
		if (!((((int)now.mutexFelines)>0)))
			continue;
		/* merge: mutexFelines = (mutexFelines-1)(0, 27, 30) */
		reached[1][27] = 1;
		(trpt+1)->bup.oval = ((int)now.mutexFelines);
		now.mutexFelines = (((int)now.mutexFelines)-1);
#ifdef VAR_RANGES
		logval("mutexFelines", ((int)now.mutexFelines));
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 14: // STATE 30 - zoo.pml:64 - [felines = (felines-1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][30] = 1;
		(trpt+1)->bup.oval = ((int)now.felines);
		now.felines = (((int)now.felines)-1);
#ifdef VAR_RANGES
		logval("felines", ((int)now.felines));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 15: // STATE 31 - zoo.pml:66 - [((felines==0))] (0:0:0 - 1)
		IfNotBlocked
		reached[1][31] = 1;
		if (!((((int)now.felines)==0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 16: // STATE 32 - zoo.pml:17 - [area = (area+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][32] = 1;
		(trpt+1)->bup.oval = ((int)now.area);
		now.area = (((int)now.area)+1);
#ifdef VAR_RANGES
		logval("area", ((int)now.area));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 17: // STATE 38 - zoo.pml:17 - [mutexFelines = (mutexFelines+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[1][38] = 1;
		(trpt+1)->bup.oval = ((int)now.mutexFelines);
		now.mutexFelines = (((int)now.mutexFelines)+1);
#ifdef VAR_RANGES
		logval("mutexFelines", ((int)now.mutexFelines));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 18: // STATE 40 - zoo.pml:70 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][40] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Mouse */
	case 19: // STATE 1 - zoo.pml:12 - [((mutexMice>0))] (5:0:1 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		if (!((((int)now.mutexMice)>0)))
			continue;
		/* merge: mutexMice = (mutexMice-1)(0, 2, 5) */
		reached[0][2] = 1;
		(trpt+1)->bup.oval = ((int)now.mutexMice);
		now.mutexMice = (((int)now.mutexMice)-1);
#ifdef VAR_RANGES
		logval("mutexMice", ((int)now.mutexMice));
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 20: // STATE 5 - zoo.pml:23 - [mice = (mice+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][5] = 1;
		(trpt+1)->bup.oval = ((int)now.mice);
		now.mice = (((int)now.mice)+1);
#ifdef VAR_RANGES
		logval("mice", ((int)now.mice));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 21: // STATE 6 - zoo.pml:25 - [((mice==1))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][6] = 1;
		if (!((((int)now.mice)==1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 22: // STATE 7 - zoo.pml:12 - [((area>0))] (16:0:1 - 1)
		IfNotBlocked
		reached[0][7] = 1;
		if (!((((int)now.area)>0)))
			continue;
		/* merge: area = (area-1)(0, 8, 16) */
		reached[0][8] = 1;
		(trpt+1)->bup.oval = ((int)now.area);
		now.area = (((int)now.area)-1);
#ifdef VAR_RANGES
		logval("area", ((int)now.area));
#endif
		;
		/* merge: .(goto)(0, 14, 16) */
		reached[0][14] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 23: // STATE 15 - zoo.pml:17 - [mutexMice = (mutexMice+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][15] = 1;
		(trpt+1)->bup.oval = ((int)now.mutexMice);
		now.mutexMice = (((int)now.mutexMice)+1);
#ifdef VAR_RANGES
		logval("mutexMice", ((int)now.mutexMice));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 24: // STATE 17 - zoo.pml:12 - [((feedinglot>0))] (21:0:1 - 1)
		IfNotBlocked
		reached[0][17] = 1;
		if (!((((int)now.feedinglot)>0)))
			continue;
		/* merge: feedinglot = (feedinglot-1)(0, 18, 21) */
		reached[0][18] = 1;
		(trpt+1)->bup.oval = ((int)now.feedinglot);
		now.feedinglot = (((int)now.feedinglot)-1);
#ifdef VAR_RANGES
		logval("feedinglot", ((int)now.feedinglot));
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 25: // STATE 21 - zoo.pml:32 - [c = (c+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][21] = 1;
		(trpt+1)->bup.oval = ((int)now.c);
		now.c = (((int)now.c)+1);
#ifdef VAR_RANGES
		logval("c", ((int)now.c));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 26: // STATE 22 - zoo.pml:33 - [assert((c<3))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][22] = 1;
		spin_assert((((int)now.c)<3), "(c<3)", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 27: // STATE 23 - zoo.pml:34 - [c = (c-1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][23] = 1;
		(trpt+1)->bup.oval = ((int)now.c);
		now.c = (((int)now.c)-1);
#ifdef VAR_RANGES
		logval("c", ((int)now.c));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 28: // STATE 24 - zoo.pml:17 - [feedinglot = (feedinglot+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][24] = 1;
		(trpt+1)->bup.oval = ((int)now.feedinglot);
		now.feedinglot = (((int)now.feedinglot)+1);
#ifdef VAR_RANGES
		logval("feedinglot", ((int)now.feedinglot));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 29: // STATE 26 - zoo.pml:12 - [((mutexMice>0))] (30:0:1 - 1)
		IfNotBlocked
		reached[0][26] = 1;
		if (!((((int)now.mutexMice)>0)))
			continue;
		/* merge: mutexMice = (mutexMice-1)(0, 27, 30) */
		reached[0][27] = 1;
		(trpt+1)->bup.oval = ((int)now.mutexMice);
		now.mutexMice = (((int)now.mutexMice)-1);
#ifdef VAR_RANGES
		logval("mutexMice", ((int)now.mutexMice));
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 30: // STATE 30 - zoo.pml:38 - [mice = (mice-1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][30] = 1;
		(trpt+1)->bup.oval = ((int)now.mice);
		now.mice = (((int)now.mice)-1);
#ifdef VAR_RANGES
		logval("mice", ((int)now.mice));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 31: // STATE 31 - zoo.pml:40 - [((mice==0))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][31] = 1;
		if (!((((int)now.mice)==0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 32: // STATE 32 - zoo.pml:17 - [area = (area+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][32] = 1;
		(trpt+1)->bup.oval = ((int)now.area);
		now.area = (((int)now.area)+1);
#ifdef VAR_RANGES
		logval("area", ((int)now.area));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 33: // STATE 38 - zoo.pml:17 - [mutexMice = (mutexMice+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][38] = 1;
		(trpt+1)->bup.oval = ((int)now.mutexMice);
		now.mutexMice = (((int)now.mutexMice)+1);
#ifdef VAR_RANGES
		logval("mutexMice", ((int)now.mutexMice));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 34: // STATE 40 - zoo.pml:44 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][40] = 1;
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

