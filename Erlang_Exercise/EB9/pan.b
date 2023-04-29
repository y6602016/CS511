	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC :init: */

	case 3: // STATE 1
		;
		now.turn = trpt->bup.oval;
		;
		goto R999;

	case 4: // STATE 3
		;
		((P1 *)_this)->i = trpt->bup.ovals[1];
		((P1 *)_this)->i = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;
;
		;
		
	case 6: // STATE 5
		;
		now.flags[ Index(((P1 *)_this)->i, 3) ] = trpt->bup.oval;
		;
		goto R999;

	case 7: // STATE 6
		;
		((P1 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 8: // STATE 12
		;
		((P1 *)_this)->i = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 10: // STATE 14
		;
		;
		delproc(0, now._nr_pr-1);
		;
		goto R999;

	case 11: // STATE 15
		;
		((P1 *)_this)->i = trpt->bup.oval;
		;
		goto R999;

	case 12: // STATE 22
		;
		p_restor(II);
		;
		;
		goto R999;

		 /* PROC P */

	case 13: // STATE 1
		;
		now.flags[ Index(((P0 *)_this)->myId, 3) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 15: // STATE 3
		;
	/* 0 */	((P0 *)_this)->left = trpt->bup.oval;
		;
		;
		goto R999;

	case 16: // STATE 4
		;
		now.flags[ Index(((P0 *)_this)->myId, 3) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 18: // STATE 17
		;
		now.turn = trpt->bup.oval;
		;
		goto R999;

	case 19: // STATE 18
		;
		now.flags[ Index(((P0 *)_this)->myId, 3) ] = trpt->bup.oval;
		;
		goto R999;

	case 20: // STATE 19
		;
		p_restor(II);
		;
		;
		goto R999;
	}

