use lib './lib';
use lib '.';
use LatentSemanticAnalysisWorkflows;

# Shortcut
my $pLSAMONCOMMAND = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommand;

#say $pLSAMONCOMMAND.parse("from aText create");

#
#say LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommand.parse('apply to item term matrix entries the functions cosine');
#
#say LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommand.parse('represent by terms cosine');
#
#say LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommand.subparse('represent by topics "cosine is good"');

# say "\n=======\n";
#
#
#
#say "\n=======\n";
##
#
# say to_LSAMon_WL('
# use lsa object lsaObj;
# represent by topics "cosine is good";
# ');
#
#say "\n=======\n";
#
# say to_LSAMon_WL('
# use lsa object lsaObj;
# represent by topics cosine similarity is good;
# echo pipeline value;
# ');

# say to_LSAMon_WL('
# use lsa object lsaObj;
# apply lsi functions idf, none, cosine;
# extract 12 topics;
# ');

#my $command = '
#cóng aText chuàngjiàn;
#make document term matrix with no stemming and automatic stop words;
#echo data summary;
#apply lsi functions global weight function idf, local term weight function none, normalizer function cosine;
#extract 12 topics using method NNMF and max steps 12;
#show topics table with 12 columns and 10 terms;
#show thesaurus table for sing, left, home;
#';

my $command = '
create from aText;
make document term matrix with automatic stop words and without stemming rules;
echo data summary;
apply lsi functions global weight function idf, local term weight function none, normalizer function cosine;
extract 12 topics using method NNMF and max steps 12;
show topics table with 12 columns and 10 terms;
show thesaurus table for sing, left, home;
';


say "\n=======\n";

say to_LSAMon_Python($command);

say "\n=======\n";

say to_LSAMon_R($command);

say "\n=======\n";

say to_LSAMon_WL($command);

say "\n=======\n";
#
#my $commandBulgarian = '
#създай от aText;
#направи документи-термини матрица без коренуване и с автоматични стоп думи;
#отрази обобщение на данните;
#приложи lsi функциите глобално теглова функция idf, локално теглова функция none, нормализатор функция косинус;
#извлечи 12 теми, използвайки метод NNMF и максимален брой стъпки 12;
#покажи таблица с теми с 12 колони и 10 термина;
#покажи таблицата на тезауруса за пеене, вляво, вкъщи;
#';
#
#say "\n=======\n";
#
#my $commandChinese = '
#從aText創建；
#製作沒有詞乾和自動停用詞的文檔術語矩陣；
#回顯數據摘要；
#應用lsi函數全局權重函數idf，局部項權重函數none，歸一化函數餘弦；
#使用方法NNMF和最多12個步驟提取12個主題；
#顯示包含12列和10個詞的主題表；
#顯示敘詞表以便在左邊唱歌
#';


