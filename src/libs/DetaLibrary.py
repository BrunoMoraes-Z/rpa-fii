import datetime
import typing

from deta import Deta
from robot.api.deco import keyword


class DetaLibrary(object):

    @keyword(name='Connect To Deta')
    def connect_to_deta(self, project_key: str = None, project_id: str = None) -> None:
        self.deta = Deta(project_key, project_id)

    @keyword(name='Select Base')
    def select_base(self, base_name: str) -> None:
        self.db = self.deta.Base(base_name)

    @keyword(name='Get From Base')
    def get_from_base(self, key: str):
        if not self.db: raise 'Use "Select Base  <base_name>" before.'

        return self.db.get(key)

    @keyword(name='Delete From Base')
    def delete_from_base(self, key: str):
        if not self.db: raise 'Use "Select Base  <base_name>" before.'

        return self.db.delete(key)

    @keyword(name='Insert In A Base')
    def insert_in_a_base(
        self,
        data: typing.Union[dict, list, str, int, bool],
        key: str = None,
        *,
        expire_in: int = None,
        expire_at: typing.Union[int, float, datetime.datetime] = None,
    ):
        if not self.db: raise 'Use "Select Base  <base_name>" before.'

        return self.db.insert(data=data, key=key, expire_in=expire_in, expire_at=expire_at)

    @keyword(name='Put In A Base')
    def put_in_a_base(
        self,
        data: typing.Union[dict, list, str, int, bool],
        key: str = None,
        *,
        expire_in: int = None,
        expire_at: typing.Union[int, float, datetime.datetime] = None,
    ):
        if not self.db: raise 'Use "Select Base  <base_name>" before.'

        return self.db.put(data=data, key=key, expire_in=expire_in, expire_at=expire_at)

    @keyword(name='Put Many In A Base')
    def put_many_in_a_base(
        self,
        items: typing.List[typing.Union[dict, list, str, int, bool]],
        *,
        expire_in: int = None,
        expire_at: typing.Union[int, float, datetime.datetime] = None,
    ):
        if not self.db: raise 'Use "Select Base  <base_name>" before.'

        return self.db.put_many(items=items, expire_in=expire_in, expire_at=expire_at)

    @keyword(name='Fetch From Base')
    def fetch_from_base(
        self,
        query: typing.Union[dict, list] = None,
        *,
        limit: int = 1000,
        last: str = None,
    ):
        if not self.db: raise 'Use "Select Base  <base_name>" before.'

        return self.db.fetch(query=query, limit=limit, last=last)

    @keyword(name='Update Base')
    def update_base(
        self,
        updates: dict,
        key: str,
        *,
        expire_in: int = None,
        expire_at: typing.Union[int, float, datetime.datetime] = None,
    ):
        if not self.db: raise 'Use "Select Base  <base_name>" before.'

        return self.db.update(updates=updates, key=key, expire_in=expire_in, expire_at=expire_at)