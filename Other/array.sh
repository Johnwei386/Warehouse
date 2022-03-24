#!/bin/bash

# 遍历数组

# 各功能模块相对目录
GATEWAY="ciic-base-gateway"                           # 网关服务    
MESSAGE="ciic-event-message"                          # 消息队列
AUTH="ciic-ihr-auth"                                  # 鉴权服务
UPMS="ciic-ihr-upms"                                  # 用户授权
BASE_FILE="ciic-base-file"                            # 文件服务
SYS="ciic-ihr-sys"                                    # 参数管理
ORG="ciic-ihr-org"                                    # 机构管理
XXLJOB="ciic-base-xxl-job/ciic-base-xxl-job-admin"    # 定时任务
BNF="ciic-ihr-bnf"                                    # 福利服务
CDR="ciic-ihr-cdr"                                    # 干部管理
OOT="ciic-ihr-oot"                                    # 外事服务
PRT="ciic-ihr-prt"                                    # 党务管理
SALARY="ciic-ihr-salary"                              # 薪酬管理
TRN="ciic-ihr-trn"                                    # 培训服务
WKF="ciic-ihr-wkf"                                    # 流程服务

# 基础服务数组
base_services_arr=( $GATEWAY $MESSAGE $AUTH $UPMS $BASE_FILE $SYS )

WHILE_BUILD=true

if [ $WHILE_BUILD = true ];then
    for service in ${base_services_arr[@]}
    do
        echo $service
    done
fi
