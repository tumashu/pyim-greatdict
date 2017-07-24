;;; pyim-greatdict.el --- A pyim dict, which include three million words.

;; * Header
;; TODO Copyright

;; Author: Wenliang Xiao <kevin.xiaowl@gmail.com>
;; Maintainer: Feng Shu <tumashu@163.com>
;; URL: https://github.com/tumashu/pyim-greatdict
;; Version: 0.0.1
;; Keywords: convenience, Chinese, pinyin, input-method, complete

;;; Commentary:
;; * pyim-greatdict README                                        :README:doc:

;; ** 简介
;; pyim-greatdict 是一个 pyim 词库， 由 [[https://github.com/xiaowl][WenLiang Xiao ]] 同学根据他
;; 之前自己使用的一个 NLP 语料库整理而成，这个词库词条比较多，包涵大概330万左右的词条，
;; 文件大小大约 80M, 希望可以免去大多数人到处找字典的苦恼。

;; WenLiang Xiao 同学 [[https://github.com/tumashu/pyim/pull/77][最初]] 将这个词库通过百度网盘发布，
;; 我个人认为这个词库文件对 pyim 很重要，所以为其开启一个项目，并将这个词库命名为：greatdict.

;; ** 安装和使用

;; 1. 配置melpa源，参考：http://melpa.org/#/getting-started
;; 2. M-x package-install RET pyim-greatdict RET
;; 3. 在emacs配置文件中（比如: ~/.emacs）添加如下代码：
;;    #+BEGIN_EXAMPLE
;;    (require 'pyim-greatdict)
;;    (pyim-greatdict-enable)
;;    #+END_EXAMPLE

;; ** NLP 语料库
;; pyim-greatdict 使用 NLP 语料库由 [[https://github.com/lshb][刘邵博]] 同学开发，2014 年发布在 “中国自然语言开源组织”
;; 的网站，具体网址为：http://www.nlpcn.org/resource/25


;; 语料库的发布包中包含了以下的信息（其中 email 地址隐藏）：

;; #+BEGIN_EXAMPLE
;; 作者：刘邵博         版本：v1
;; 此词典为个人综合多本词典整合的一个大词典，词典共有词汇3669216个词汇。
;; 词典结构为：词语\t词性\t词频。
;; 词频是用ansj分词对270G新闻语料进行分词统计词频获得。
;; 本人感觉需要特别说明的是词典整理过程中存在部分词汇无法确定是什么词性，对词性进行特别标注：nw和comb
;;     1、词性nw表示本身不知道是什么词性。
;;     2、词性comb表示通过ansj的nlp分词之后又被拆成了两个词。

;; 官网：http://www.nlpcn.org
;; #+END_EXAMPLE


;; 为了进一步了解相关信息，我给 [[https://github.com/lshb][刘邵博]] 同学发了 Email 并得到如下回复，确定这个语料库可以自由的使用：

;; #+BEGIN_EXAMPLE
;; 回复：咨询一些关于“ 词典360万（个人整理）.txt”的一些情况

;;     发件人：
;;     lshb1986@qq.com<???????@qq.com>
;;     收件人：
;;     我<???????@163.com>
;;     时   间：
;;     2016年06月02日 16:00 (星期四)


;; 你好，tumashu
;;       这个词库是发布在了http://www.nlpcn.org网站上，并没有在其他地方发布，至于微博中的信息发布是网站做的自动转载宣传放上去的。对于词典当时用到的一些其他词库这些信息，我只能给您sorry了（确实不大记得了，当时忘记整理这个信息了），不过，用到其他词库都是开源词库，这个请放心。

;; ------------------ 原始邮件 ------------------
;; 发件人: "tumashu";<???????@163.com>;
;; 发送时间: 2016年6月2日(星期四) 下午3:08
;; 收件人: "简单就是我"<????????@qq.com>;
;; 主题: 咨询一些关于“ 词典360万（个人整理）.txt”的一些情况

;; 你好，刘同学

;;     我是 emacs拼音输入法： pyim 的维护者 ，https://github.com/tumashu/pyim      xiaowl 同学 https://github.com/xiaowl  根据你 2014 年制作的
;; "词典360万（个人整理）.txt" 为 pyim 制作了一个比较好的输入法词库， 由于目前 pyim 没有内置词库，所以，我很想将这个词库作为默认 pyim 的默认词库来发布， 所以我需要从你这里了解一下 “"词典360万（个人整理）.txt"” 的一些信息：
;; 1.  "词典360万（个人整理）.txt"  的说明文档中没有说明这个文件使用什么协议发布的， 可不可以明确一下？
;; 2.  你提到这个文件是 “综合多个词典整合”，你可以告诉我这些词典的具体信息吗，是 开源的词典还是 闭源的？

;; -------------------------------------------------------------------------------------------------------------------------------------------------------------------
;; 作者：刘邵博         版本：v1
;; 此词典为个人综合多本词典整合的一个大词典，词典共有词汇3669216个词汇。
;; 词典结构为：词语\t词性\t词频。
;; 词频是用ansj分词对270G新闻语料进行分词统计词频获得。
;; 本人感觉需要特别说明的是词典整理过程中存在部分词汇无法确定是什么词性，对词性进行特别标注：nw和comb
;;     1、词性nw表示本身不知道是什么词性。
;;     2、词性comb表示通过ansj的nlp分词之后又被拆成了两个词。

;; 官网：http://www.nlpcn.org
;; --------------------------------------------------------------------------------------------------------------------------------------------------------------------
;; #+END_EXAMPLE

;;; Code:
;; * 代码                                                               :code:

;;;###autoload
(defun pyim-greatdict-enable ()
  "Add greatdict to pyim."
  (interactive)
  (let* ((file (concat (file-name-directory
                        (locate-library "pyim-greatdict.el"))
                       "pyim-greatdict.pyim.gz")))
    (when (file-exists-p file)
      (if (featurep 'pyim)
          (pyim-extra-dicts-add-dict
           `(:name "Greatdict-elpa"
                   :file ,file
                   :coding utf-8-unix
                   :dict-type pinyin-dict
                   :elpa t))
        (message "pyim 没有安装，pyim-greatdict 启用失败。")))))

;; * Footer

(provide 'pyim-greatdict)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; pyim-greatdict.el ends here
