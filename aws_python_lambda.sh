command=$1
pip_version=$2
params="--upgrade"
if [ "$command" == "-help" -o "$command" == "" ];then
        echo "功能：实现python包一键打包,需要给一个requirements.txt";
        echo "    -help: 获取帮助";
        echo "    -zip : 安装并打包python包,第二个参数请给pip版本";
        echo "    -up : 打包lambda函数，并上传,第二个参数请给aws的function函数名";
elif [ "$command" == "-zip" ];then
        if [ ! -f "requirements.txt" ];then
                echo "ERROR: 对不起你需要给一个requirements.txt"
                exit;
        fi
        echo "RUN: mkdir -p python"
        mkdir -p python;
        if [ "$pip_version" == "" ];then
                pip_version="pip3";
        fi
        echo "RUN: ${pip_version} install --target python -r requirements.txt ${params}"
        ${pip_version} install --target python -r requirements.txt ${params};
        echo "RUN: rm -rf python.zip"
        rm -rf python.zip;
        echo "zip -r python.zip ./python"
        zip -r python.zip ./python;
        echo "DONE!"
elif [ "$command" == "-up" ];then
		if [ "$2" == "" ];then
			echo "请给第二个参数：aws的function函数名";
			exit;
		fi
		echo "RUN: rm -rf function.zip"
        rm -rf function.zip
        echo "RUN: zip -r function.zip * ..."
        zip --exclude python.zip --exclude aws_python_lambda.sh -r function.zip *
        echo "RUN: aws lambda update-function-code --function-name $2 --zip-file fileb://function.zip"
        aws lambda update-function-code --function-name $2 --zip-file fileb://function.zip
        echo "DONE!"

else
        echo "ERROR: 对不起，暂时不支持命令 $command";

fi
