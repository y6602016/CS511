	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC Feline */

	case 3: // STATE 2
		;
		now.mutexFelines = trpt->bup.oval;
		;
		goto R999;

	case 4: // STATE 5
		;
		now.felines = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 6: // STATE 8
		;
		now.area = trpt->bup.oval;
		;
		goto R999;

	case 7: // STATE 15
		;
		now.mutexFelines = trpt->bup.oval;
		;
		goto R999;

	case 8: // STATE 18
		;
		now.feedinglot = trpt->bup.oval;
		;
		goto R999;

	case 9: // STATE 21
		;
		now.c = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 11: // STATE 23
		;
		now.c = trpt->bup.oval;
		;
		goto R999;

	case 12: // STATE 24
		;
		now.feedinglot = trpt->bup.oval;
		;
		goto R999;

	case 13: // STATE 27
		;
		now.mutexFelines = trpt->bup.oval;
		;
		goto R999;

	case 14: // STATE 30
		;
		now.felines = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 16: // STATE 32
		;
		now.area = trpt->bup.oval;
		;
		goto R999;

	case 17: // STATE 38
		;
		now.mutexFelines = trpt->bup.oval;
		;
		goto R999;

	case 18: // STATE 40
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC Mouse */

	case 19: // STATE 2
		;
		now.mutexMice = trpt->bup.oval;
		;
		goto R999;

	case 20: // STATE 5
		;
		now.mice = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 22: // STATE 8
		;
		now.area = trpt->bup.oval;
		;
		goto R999;

	case 23: // STATE 15
		;
		now.mutexMice = trpt->bup.oval;
		;
		goto R999;

	case 24: // STATE 18
		;
		now.feedinglot = trpt->bup.oval;
		;
		goto R999;

	case 25: // STATE 21
		;
		now.c = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 27: // STATE 23
		;
		now.c = trpt->bup.oval;
		;
		goto R999;

	case 28: // STATE 24
		;
		now.feedinglot = trpt->bup.oval;
		;
		goto R999;

	case 29: // STATE 27
		;
		now.mutexMice = trpt->bup.oval;
		;
		goto R999;

	case 30: // STATE 30
		;
		now.mice = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 32: // STATE 32
		;
		now.area = trpt->bup.oval;
		;
		goto R999;

	case 33: // STATE 38
		;
		now.mutexMice = trpt->bup.oval;
		;
		goto R999;

	case 34: // STATE 40
		;
		p_restor(II);
		;
		;
		goto R999;
	}

