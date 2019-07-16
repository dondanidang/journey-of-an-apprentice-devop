deploy:
	cd terraform; terraform apply; cd -
	cd vesto-admin-app; npm run build; cd -
	aws s3 sync vesto-admin-app/build/ s3://vesto-admin-panel-app --delete

# > subo todo excepto:
# 		- index_html
#
# > Luego subo html
#
# > sync all
#
#
# cloudfront => invalidad index_html
