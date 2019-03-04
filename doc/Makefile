BUILD = ${REPO_HOME}/build/doc

define map_dot
  $(addprefix ${BUILD}/image/, $(notdir $(patsubst %.dot, %.pdf, ${1})))
endef

define map_eps
  $(addprefix ${BUILD}/image/, $(notdir $(patsubst %.eps, %.pdf, ${1})))
endef

define rule_dot
$(call map_dot, ${1}) : ${1} 
	@dot -Tps $${<} | ps2pdf - - > $${@}
endef

define rule_eps
$(call map_eps, ${1}) : ${1} 
	@cat      $${<} | ps2pdf - - > $${@}
endef

IMAGE_SOURCES_DOT = $(wildcard ./image/*.dot)
IMAGE_TARGETS_DOT = $(foreach FILE, ${IMAGE_SOURCES_DOT}, $(call map_dot, ${FILE}))

IMAGE_SOURCES_EPS = $(wildcard ./image/*.eps)
IMAGE_TARGETS_EPS = $(foreach FILE, ${IMAGE_SOURCES_EPS}, $(call map_eps, ${FILE}))

$(foreach FILE,${IMAGE_SOURCES_DOT},$(eval $(call rule_dot,${FILE})))
$(foreach FILE,${IMAGE_SOURCES_EPS},$(eval $(call rule_eps,${FILE})))

${BUILD}/ref.pdf : ./ref.tex $(wildcard ./tex/* ./image/*)
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" pdflatex  -output-directory ${BUILD} $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" biber    --output_directory ${BUILD} $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" pdflatex  -output-directory ${BUILD} $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" biber    --output_directory ${BUILD} $(basename ${<})
	@TEXINPUTS="${TEXINPUTS}:.:${BUILD}" pdflatex  -output-directory ${BUILD} $(basename ${<})

.PHONY : image

dir   :
	@mkdir --parents ${BUILD}
	@mkdir --parents ${BUILD}/image

image : ${IMAGE_TARGETS_DOT} ${IMAGE_TARGETS_EPS}

all   : dir image ${BUILD}/ref.pdf

clean :
	@rm -rf ${BUILD}/image
	@rm -f ${BUILD}/*
