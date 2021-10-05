SHELL=/bin/sh
#
SRCS=	WRFBUCKETG2.f

OBJS=	WRFBUCKETG2.o 
OBJS_DEBUG=	WRFBUCKETG2.o 

# Tunable parameters
#
# LIBS		List of libraries
# CMD		Name of the executable
#
CMD = ./hireswfv3_bucket

LIBS =   ${G2TMPL_LIB} ${G2_LIB4} ${JASPER_LIB} ${PNG_LIB} ${Z_LIB} ${W3NCO_LIB4} ${W3EMC_LIB4} ${BACIO_LIB4} 
INC =  -I${G2_INC4} -I${G2TMPL_INC}

FFLAGS = -O   

FFLAGS_DEBUG = -O    -g -traceback -ftrapuv  -check all  -fp-stack-check

# Lines from here on down should not need to be changed.  They are the
# actual rules which make uses to build a.out.
#
all:	 $(CMD) clean

$(CMD):		$(OBJS)
	$(COMPILER) ${INC} -o $(@) $(OBJS) $(LIBS)

debug:		$(OBJS_DEBUG)
	$(COMPILER) ${INC} -o hireswfv3_bucket $(OBJS_DEBUG) $(LIBS)

$(OBJS):       
	$(COMPILER) ${INC} -c $(FFLAGS) $(@:.o=.f)

$(OBJS_DEBUG):       
	$(COMPILER) ${INC} -c $(FFLAGS_DEBUG) $(@:.o=.f)
clean:
	@rm  *.o ${CMD}
install:
	/bin/cp ${CMD} ../../../exec/fv3/
