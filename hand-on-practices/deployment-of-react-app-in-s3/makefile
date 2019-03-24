deploy:
	cd terraform; terraform apply; cd -
	# cd vesto-admin-app; npm run build; cd -
	# aws s3 sync vesto-admin-app/build/ s3://vesto-admin-panel-app --exclude "index.html"
	# aws s3 cp vesto-admin-app/build/index.html s3://vesto-admin-panel-app
	# aws s3 sync vesto-admin-app/build/ s3://vesto-admin-panel-app --delete

destroy:
	cd terraform; terraform destroy; cd -

# > subo todo excepto:
# 		- index_html
#
# > Luego subo html
#
# > sync all
#
#
# cloudfront => invalidad index_html
