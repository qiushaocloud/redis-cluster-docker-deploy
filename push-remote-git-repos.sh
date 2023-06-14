CURR_DIR=$(cd "$(dirname "$0")"; pwd)

gitName=`grep -E "url = .*.git" $CURR_DIR/.git/config|awk -F 'qiushaocloud/' '{print $2}'`

# 推送到 gitee
git remote set-url origin git@gitee.com:qiushaocloud/$gitName
git push

# 推送到 github
git remote set-url origin git@github.com:qiushaocloud/$gitName
git push

# 推送到自建的 gitea
git remote set-url origin ssh://git@gitea.qiushaocloud.top:61322/qiushaocloud/$gitName
git push

# 推送到自建的 gitlab
git remote set-url origin ssh://git@gitlab.qiushaocloud.top:61023/qiushaocloud/$gitName
git push